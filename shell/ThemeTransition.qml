pragma Singleton
import QtQuick
import Quickshell

// Hides a theme switch behind a stepped wave of cells, after the lock screen's
// grid: cells cover every screen in rings from an origin, the theme swaps
// underneath, then they clear outward. One timer steps all screens together;
// ThemeTransitionOverlay draws each screen's cells.
Singleton {
  id: root
  readonly property int cellSize: 80
  // Time to cover (and again to clear), whatever the screen size or origin.
  // Bigger screens take more rings, so each step is shorter.
  readonly property int duration: 500
  property int interval: 28
  // "idle" | "cover" | "clear"
  property string phase: "idle"
  readonly property bool running: phase !== "idle"
  property int step: 0
  property int maxRing: 0
  // The incoming palette colors the cells.
  property var incoming: Theme.palette
  // Where the switch was asked for, in screen coordinates: { screen, x, y, time }.
  // Recent picks start from there; other screens start from their center.
  property var origin: null

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

  function start() {
    if (running || Theme.requested === Theme.name) return;
    incoming = Theme.palettes[Theme.requested];
    let far = 0;
    for (const screen of Quickshell.screens)
      far = Math.max(far, layout(screen.width, screen.height,
                                 originOn(screen, screen.width, screen.height)).far);
    maxRing = far;
    // Never step faster than a frame.
    interval = Math.max(16, Math.round(duration / Math.max(1, far)));
    step = 0;
    phase = "cover";
  }

  Component.onCompleted: Theme.holdSwitch = true

  Connections {
    target: Theme
    function onRequestedChanged() { root.start(); }
  }

  Timer {
    interval: root.interval
    repeat: true
    running: root.running
    onTriggered: {
      if (root.phase === "cover") {
        if (root.step < root.maxRing) { root.step++; return; }
        // Every screen is covered: swap underneath, then clear from the origin.
        Theme.apply();
        root.step = 0;
        root.phase = "clear";
      } else if (root.step <= root.maxRing) {
        root.step++;
      } else {
        root.phase = "idle";
        root.origin = null;
        // A switch asked for while clearing runs now.
        root.start();
      }
    }
  }
}
