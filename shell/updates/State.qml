pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../installs" as Installs
import "../settings" as Settings

Singleton {
  id: root
  property string status: ""

  function start() {
    if (status !== "available") return;
    Settings.State.close();
    Quickshell.execDetached(["sh", "-c",
      'echo updating > "$1"; pm -u && echo complete > "$1" || echo failed > "$1"', "sh", statusFile.path]);
  }

  Timer {
    interval: 12 * 60 * 60 * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: check.running = true
  }

  Process {
    id: check
    command: ["pm", "-a"]
    stdout: StdioCollector { id: output }
    onExited: exitCode => {
      if (exitCode === 0 && (root.status === "" || root.status === "available"))
        root.status = output.text.trim() === "true" ? "available" : "";
    }
  }

  Timer {
    interval: 60 * 60 * 1000
    running: root.status === "complete"
    onTriggered: root.status = ""
  }

  FileView {
    id: statusFile
    path: Quickshell.env("XDG_RUNTIME_DIR") + "/pond-update"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: {
      const result = text().trim();
      if (result === "updating") {
        root.status = "updating";
        Installs.State.update("system-update", "Updating", "installing", -1, "");
      } else if (root.status === "updating" && result === "complete") {
        root.status = "complete";
        Installs.State.update("system-update", "Update complete", "installed", -1, "");
      } else if (root.status === "updating" && result === "failed") {
        root.status = "available";
        Installs.State.update("system-update", "Update failed", "failed", -1, "");
      }
    }
  }
}
