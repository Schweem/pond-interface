import QtQuick
import "." as Updates
import ".." as Shell

Rectangle {
  id: root
  readonly property string status: Updates.State.status
  readonly property bool available: status === "available"
  readonly property color foreground: status === "complete" ? "#cef058" : "#cba6f7"

  implicitWidth: content.width + 24
  implicitHeight: 40
  radius: 8
  color: Qt.alpha(foreground, 0.1)
  activeFocusOnTab: available
  Accessible.role: available ? Accessible.Button : Accessible.StaticText
  Accessible.name: label.text
  Accessible.onPressAction: Updates.State.start()
  Keys.onReturnPressed: Updates.State.start()
  Keys.onSpacePressed: Updates.State.start()

  Row {
    id: content
    anchors.centerIn: parent
    spacing: 6

    Image {
      anchors.verticalCenter: parent.verticalCenter
      visible: root.status === "complete"
      source: Qt.resolvedUrl("../assets/updates/complete.svg")
    }
    Text {
      id: label
      anchors.verticalCenter: parent.verticalCenter
      text: root.available ? "Update available" : root.status === "updating" ? "Updating" : "Update complete"
      color: root.foreground
      font.family: Shell.Theme.fontFamily
      font.pixelSize: 13
      font.weight: Font.Medium
    }
    Image {
      anchors.verticalCenter: parent.verticalCenter
      visible: root.available
      source: Qt.resolvedUrl("../assets/updates/available.svg")
    }
  }

  MouseArea {
    anchors.fill: parent
    enabled: root.available
    cursorShape: Qt.PointingHandCursor
    onClicked: Updates.State.start()
  }
}
