pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Locks behind a cover: cells cover the screens, the lock screen comes up,
// and the cover clears underneath it once session.py has confirmed the lock
// is secure (or given up). Locks straight away if another transition is
// running.
Singleton {
  id: root

  function lock() {
    if (!ScreenTransition.run({ hold: true, covered: () => { locker.running = true; } }))
      Quickshell.execDetached(locker.command);
  }

  Process {
    id: locker
    command: ["python3", Quickshell.shellDir + "/settings/session.py", "lock"]
    onExited: ScreenTransition.release()
  }
}
