import QtQuick
import Quickshell
import Quickshell.Io

// Opens each login on covered screens that clear once the shell has drawn,
// hiding its windows mapping in one by one. The cover starts in the greeter's
// color, which niri's backdrop also uses, so the handoff from the greeter
// shows no seam. A runtime flag, gone at logout, keeps shell restarts within
// a session from covering again.
Scope {
  id: root
  // The greeter's background, carried through the compositor handoff.
  readonly property color handoff: "#1a1409"
  // Windows that must draw before clearing: the wallpaper and sidebar on
  // every screen.
  readonly property int expected: Quickshell.screens.length * 2
  property int drawnCount: 0
  property bool holding: false

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
    if (flag.text() !== "") return;
    flag.setText("revealed\n");
    holding = ScreenTransition.hold({ base: handoff });
  }
}
