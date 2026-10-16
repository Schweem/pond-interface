import QtQuick
import QtQuick.Effects
import "." as Updates
import ".." as Shell
import "../settings" as Settings

Rectangle {
  id: root
  readonly property string status: Updates.State.status
  readonly property bool actionable: status === "available" || status === "restart"
  readonly property bool restartHovered: status === "restart" && pointer.containsMouse
  readonly property color accent: status === "complete" ? "#cef058" : "#cba6f7"
  readonly property color foreground: restartHovered ? "#3f1d68" : accent

  function activate() {
    if (status === "available") Updates.State.start();
    else if (status === "restart") Settings.State.requestSessionAction("reboot");
  }

  implicitWidth: content.width + 24
  implicitHeight: 40
  radius: 8
  color: restartHovered ? accent : Qt.alpha(accent, 0.1)
  activeFocusOnTab: actionable
  Accessible.role: actionable ? Accessible.Button : Accessible.StaticText
  Accessible.name: label.text
  Accessible.onPressAction: activate()
  Keys.onReturnPressed: activate()
  Keys.onSpacePressed: activate()

  Row {
    id: content
    anchors.centerIn: parent
    spacing: 6

    Image {
      anchors.verticalCenter: parent.verticalCenter
      visible: root.status === "complete"
      source: Qt.resolvedUrl("../assets/updates/complete.svg")
    }
    Image {
      anchors.verticalCenter: parent.verticalCenter
      visible: root.status === "restart"
      source: Qt.resolvedUrl("../assets/updates/restart.svg")
      layer.enabled: true
      layer.effect: MultiEffect { colorization: 1; colorizationColor: root.foreground }
    }
    Text {
      id: label
      anchors.verticalCenter: parent.verticalCenter
      text: ({
        available: "Update available", updating: "Updating",
        complete: "Update complete", restart: "Restart recommended"
      })[root.status] ?? ""
      color: root.foreground
      font.family: Shell.Theme.fontFamily
      font.pixelSize: 13
      font.weight: Font.Medium
    }
    Image {
      anchors.verticalCenter: parent.verticalCenter
      visible: root.status === "available"
      source: Qt.resolvedUrl("../assets/updates/available.svg")
    }
  }

  Text {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.baseline: parent.top
    anchors.baselineOffset: -14
    visible: root.restartHovered
    text: "Click to restart"
    color: "#cba6f7"
    font.family: Shell.Theme.fontFamily
    font.pixelSize: 13
    font.weight: Font.Medium
  }

  MouseArea {
    id: pointer
    anchors.fill: parent
    enabled: root.actionable
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.activate()
  }
}
