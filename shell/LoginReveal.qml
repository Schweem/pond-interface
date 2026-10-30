import QtQuick
import Quickshell
import Quickshell.Io

// Opens each login on covered screens that clear once the shell has drawn,
// hiding its windows mapping in one by one. The wallpaper and sidebar stay
// unmapped until every screen's cover has drawn, so neither can beat it to
// the screen. The cover starts in the greeter's color, which niri's backdrop
// also uses, so the handoff from the greeter shows no seam. A runtime flag,
// gone at logout, keeps shell restarts within a session from covering again.
Scope {
  id: root
  // The greeter's background, carried through the compositor handoff.
  readonly property color handoff: "#1a1409"
  // Windows that must draw before clearing: the wallpaper and sidebar on
  // every screen.
  readonly property int expected: Quickshell.screens.length * 2
  property int drawnCount: 0
  property int coveredCount: 0
  property bool decided: false
  property bool holding: false
  // Whether the shell's windows may map: once the cover is up, or straight
  // away when there is none.
  readonly property bool ready: decided
      && (!holding || coveredCount >= Quickshell.screens.length)

  // Report from each screen's cover once it has drawn.
  function covered() {
    if (holding) coveredCount++;
  }

  // Report from a FirstFrame in each expected window.
  function drawn() {
    if (!holding) return;
    drawnCount++;
    if (drawnCount >= expected) settle.restart();
  }

  FileView {
    id: flag
    path: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/pond-shell-revealed"
    blockAllReads: true
    printErrors: false
  }
  // Clears anyway if a window never draws (one left hidden, say).
  Timer {
    id: giveUp
    interval: 2000
    running: root.holding
    onTriggered: settle.restart()
  }
  // A beat for the frames just swapped to reach the screen.
  Timer {
    id: settle
    interval: 50
    onTriggered: {
      root.holding = false;
      ScreenTransition.release();
    }
  }
  Component.onCompleted: {
    if (flag.text() === "") {
      flag.setText("revealed\n");
      holding = ScreenTransition.hold({ base: handoff });
    }
    decided = true;
  }
}
