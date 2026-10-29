pragma Singleton

import QtQuick
import "." as Settings
import "../bluetooth" as Bluetooth
import ".." as Shell
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool opened: false
  property string page: ""
  property var pageHistory: []
  property string outputName: ""
  signal opening
  property string pendingSessionAction: ""

  readonly property var sessionActions: [
    "lock", "suspend", "reboot", "shutdown"
  ]
  readonly property var pages: [
    "appearance", "information", "manual", "display", "arrange", "system", "mouse", "keyboard", "timezone"
  ]

  Timer {
    id: sessionActionDelay
    interval: Settings.Style.exitDuration
    onTriggered: root.runSessionAction()
  }

  // Power actions run attached so a refusal can uncover the screen again.
  Process {
    id: powerAction
    onExited: exitCode => { if (exitCode !== 0) Shell.ScreenTransition.release(); }
  }

  function runSessionAction() {
    const action = root.pendingSessionAction;
    root.pendingSessionAction = "";
    const command = ["python3", Quickshell.shellDir + "/settings/session.py", action];
    if (action === "reboot" || action === "shutdown") {
      powerAction.command = command;
      powerAction.running = true;
    } else if (action !== "") {
      Quickshell.execDetached(command);
    } else {
      Shell.ScreenTransition.release();
    }
  }

  function open(requestedOutputName, initialPage = "") {
    sessionActionDelay.stop();
    pendingSessionAction = "";
    outputName = requestedOutputName || focusedOutputName();
    pageHistory = [];
    page = initialPage;
    opening();
    opened = true;
  }

  function close() {
    opened = false;
  }

  function openPage(name) {
    if (pages.indexOf(name) < 0) return;
    pageHistory = pageHistory.concat(page);
    page = name;
  }

  function back() {
    if (!pageHistory.length) { close(); return; }
    page = pageHistory[pageHistory.length - 1];
    pageHistory = pageHistory.slice(0, -1);
  }

  function toggle(requestedOutputName) {
    const targetOutput = requestedOutputName || focusedOutputName();
    if (opened && outputName === targetOutput)
      close();
    else
      open(targetOutput);
  }

  function requestSessionAction(action) {
    if (sessionActions.indexOf(action) < 0)
      return;
    pendingSessionAction = action;
    opened = false;
    // Powering off ends the session, so the screens cover and stay covered.
    const power = action === "reboot" || action === "shutdown";
    if (power && Shell.ScreenTransition.run({ hold: true, covered: runSessionAction }))
      return;
    sessionActionDelay.restart();
  }

  function openBluetooth() {
    const targetOutput = outputName || focusedOutputName();
    close();
    Bluetooth.State.requestPanel("open", targetOutput);
  }

  function focusedOutputName() {
    if (Shell.NiriMsg.focusedOutputName !== "")
      return Shell.NiriMsg.focusedOutputName;
    return Quickshell.screens.length ? Quickshell.screens[0].name : "";
  }
}
