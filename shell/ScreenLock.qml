pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Locks behind a cover: cells cover the screens, then the lock screen opens
// under the same cells and clears them to show itself. The shell's cover
// clears underneath once session.py has confirmed the lock is secure (or
// given up). Locks straight away if another transition is running.
Singleton {
  id: root
  readonly property string session: Quickshell.shellDir + "/settings/session.py"

  function lock() {
    if (!ScreenTransition.run({ hold: true, covered: () => {
      // The lock screen lays its cells out from the same origin; a screen
      // name that matches none starts every screen from its center.
      const origin = ScreenTransition.origin;
      const palette = ScreenTransition.palette;
      locker.command = ["python3", session, "lock",
                        palette.transitionFill.toString(), palette.transitionEdge.toString(),
                        origin?.screen || "*", String(origin?.x ?? 0), String(origin?.y ?? 0)];
      locker.running = true;
    } }))
      Quickshell.execDetached(["python3", session, "lock"]);
  }

  Process {
    id: locker
    onExited: ScreenTransition.release()
  }
}
