import QtQuick
import Quickshell
import Quickshell.Io

// Opens each login on covered screens that clear once the shell has settled,
// hiding its windows mapping in one by one. A runtime flag, gone at logout,
// keeps shell restarts within a session from covering again.
Scope {
  id: root
  // Time for the wallpaper and panels to draw underneath before clearing.
  property int settleTime: 400

  FileView {
    id: flag
    path: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/pond-shell-revealed"
    blockAllReads: true
    printErrors: false
  }

  Timer {
    id: settle
    interval: root.settleTime
    onTriggered: ScreenTransition.release()
  }

  Component.onCompleted: {
    if (flag.text() !== "") return;
    flag.setText("revealed\n");
    if (ScreenTransition.hold({})) settle.restart();
  }
}
