import QtQuick
import "../.." as Shell
Rectangle {
  id: root
  property string label
  property bool selected: false
  property bool arranging: false
  property bool dragging: false
  property bool hovered: false
  radius: 12
  color: selected || dragging ? Shell.Theme.palette.accentSurface : hovered || activeFocus ? (arranging ? Shell.Theme.palette.controlRaised : Shell.Theme.palette.controlHover) : arranging ? Shell.Theme.palette.controlHover : Shell.Theme.palette.controlFill
  border.width: selected || dragging ? 1 : 0
  border.color: Shell.PanelStyle.accent
  Text {
    anchors.centerIn: parent
    width: parent.width - 16
    text: root.label
    color: root.selected || root.dragging ? Shell.PanelStyle.accent : Shell.Theme.palette.foregroundMuted
    font.family: Shell.Theme.fontFamily
    font.pixelSize: 13; font.weight: Font.Medium
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.Wrap; maximumLineCount: 2; elide: Text.ElideRight
  }
}
