import QtQuick
import "." as Notifications
import ".." as Shell

Rectangle {
  id: root

  signal clicked
  property bool compact: false
  readonly property bool hovered: pointer.containsMouse

  implicitWidth: compact ? 16 : Notifications.Style.closeSize
  implicitHeight: implicitWidth
  radius: 4
  color: compact ? Shell.Theme.palette.closeCompact : pointer.containsMouse
      ? Notifications.Style.closeHover : Shell.Theme.palette.control
  antialiasing: true

  Behavior on color {
    enabled: !root.compact
    ColorAnimation {
      duration: Shell.Theme.sidebarHoverDuration
      easing.type: Easing.OutCubic
    }
  }

  Shell.Glyph {
    anchors.centerIn: parent
    width: root.compact ? 12 : Notifications.Style.closeIconSize
    height: width
    source: Qt.resolvedUrl("../assets/close.svg")
    sourceSize: Qt.size(width * 2, height * 2)
    fillMode: Image.PreserveAspectFit
    smooth: true
    antialiasing: true
  }

  MouseArea {
    id: pointer
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
