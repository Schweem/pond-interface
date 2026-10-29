pragma Singleton
import QtQuick
import Quickshell

// Hides a change behind a stepped wave of cells, after the lock screen's grid:
// cells cover every screen in rings from an origin, the change happens
// underneath, then they clear outward. A change the screen shouldn't come back
// from (powering off) holds the cover instead. One timer steps all screens
// together; ScreenTransitionOverlay draws each screen's cells. Scenarios such
// as ThemeSwitchTransition call run().
Singleton {
  id: root
  readonly property int cellSize: 80
  // Time to cover (and again to clear), whatever the screen size or origin.
  // Bigger screens take more rings, so each step is shorter.
  readonly property int duration: 500
  // A held cover clears after this anyway, in case the change never came.
  readonly property int holdTimeout: 15000
  property int interval: 28
  // "idle" | "cover" | "held" | "clear"
  property string phase: "idle"
  readonly property bool running: phase !== "idle"
  property int step: 0
  property int maxRing: 0
  // Colors the cells; a theme switch passes the incoming palette.
  property var palette: Theme.palette
  // Where the change was asked for, in screen coordinates: { screen, x, y, time }.
  // Recent picks start from there; other screens start from their center.
  property var origin: null
  property var request: null
  signal finished

  function startFrom(item) {
    const window = item.QsWindow.window;
    const point = item.mapToItem(null, item.width / 2, item.height / 2);
    origin = { screen: window?.screen?.name ?? "", x: point.x, y: point.y, time: Date.now() };
  }

  function originOn(screen, width, height) {
    const recent = origin && Date.now() - origin.time < 3000;
    return recent && origin.screen === screen.name
        ? Qt.point(origin.x, origin.y) : Qt.point(width / 2, height / 2);
  }

  // Diamond rings: grid steps away from the origin cell.
  function ring(i, j) { return Math.abs(i) + Math.abs(j); }

  // Cell grid for a screen, laid out so one cell is centered on the origin.
  function layout(width, height, point) {
    const size = cellSize;
    const left = Math.ceil((point.x - size / 2) / size);
    const top = Math.ceil((point.y - size / 2) / size);
    const cols = left + Math.ceil((width - point.x - size / 2) / size) + 1;
    const rows = top + Math.ceil((height - point.y - size / 2) / size) + 1;
    const far = Math.max(ring(left, top), ring(cols - 1 - left, top),
                         ring(left, rows - 1 - top), ring(cols - 1 - left, rows - 1 - top));
    return { x: point.x, y: point.y, left, top, cols, rows, far };
  }

  // next: { palette, covered, hold }. covered() runs once every screen is
  // covered; hold keeps them covered until release(). False if one is running.
  function run(next) {
    if (running) return false;
    request = next;
    palette = next.palette ?? Theme.palette;
    let far = 0;
    for (const screen of Quickshell.screens)
      far = Math.max(far, layout(screen.width, screen.height,
                                 originOn(screen, screen.width, screen.height)).far);
    maxRing = far;
    // Never step faster than a frame.
    interval = Math.max(16, Math.round(duration / Math.max(1, far)));
    step = 0;
    phase = "cover";
    return true;
  }

  // Clear a held cover from its origin.
  function release() {
    if (phase !== "held") return;
    holdTimer.stop();
    step = 0;
    phase = "clear";
  }

  Timer {
    interval: root.interval
    repeat: true
    running: root.running && root.phase !== "held"
    onTriggered: {
      if (root.phase === "cover") {
        if (root.step < root.maxRing) { root.step++; return; }
        // Every screen is covered: change underneath, then clear or hold.
        const request = root.request;
        if (request.hold) {
          root.phase = "held";
          holdTimer.restart();
          request.covered?.();
        } else {
          request.covered?.();
          root.step = 0;
          root.phase = "clear";
        }
      } else if (root.step <= root.maxRing) {
        root.step++;
      } else {
        root.phase = "idle";
        root.origin = null;
        root.request = null;
        root.finished();
      }
    }
  }

  Timer {
    id: holdTimer
    interval: root.holdTimeout
    onTriggered: root.release()
  }
}
