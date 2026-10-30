import QtQuick
import "." as Appearance
import "../.." as Shell

Rectangle {
  id: root
  property bool dynamic: false
  property bool selected: false
  signal clicked
  implicitHeight: 64
  z: selected ? 1 : 0
  topLeftRadius: dynamic ? 12 : 0
  topRightRadius: dynamic ? 12 : 0
  bottomLeftRadius: dynamic ? 0 : 12
  bottomRightRadius: dynamic ? 0 : 12
  color: hover.hovered || activeFocus ? Shell.Theme.palette.controlHover : selected ? Shell.Theme.palette.controlSelected : "transparent"
  border.width: 1
  border.color: selected ? Shell.PanelStyle.accent : hover.hovered || activeFocus ? Shell.Theme.palette.controlBorderHover : Shell.PanelStyle.border
  activeFocusOnTab: true
  Accessible.role: Accessible.Button
  Accessible.name: dynamic ? "Theme wallpaper" : "Choose a custom wallpaper"
  Accessible.checked: selected
  Keys.onReturnPressed: clicked()
  Keys.onSpacePressed: clicked()
  Accessible.onPressAction: clicked()
  Behavior on color { ColorAnimation { duration: 170; easing.type: Easing.OutCubic } }
  Behavior on border.color { ColorAnimation { duration: 170; easing.type: Easing.OutCubic } }
  Text {
    x: 20; y: 15
    text: root.dynamic ? "Theme" : "Custom"
    color: Shell.Theme.palette.foregroundBright; font.family: Shell.Theme.fontFamily; font.pixelSize: 13
  }
  Text {
    x: 20; y: 32
    text: root.dynamic ? "Follows the current theme" : "Set your own wallpaper"
    color: Qt.alpha(Shell.Theme.palette.overlay, 128 / 255); font.family: Shell.Theme.fontFamily; font.pixelSize: 13
  }
  Rectangle {
    visible: root.dynamic
    x: parent.width - 90; y: 19; width: 70; height: 26; radius: 4
    color: Shell.Theme.palette.wallpaperColor
    border.width: 1; border.color: Shell.PanelStyle.border
  }
  Shell.Glyph {
    visible: !root.dynamic && !Appearance.State.wallpaperPath
    x: parent.width - 44; y: 20; width: 24; height: 24
    source: Qt.resolvedUrl("../../assets/appearance/wallpaper.svg")
  }
  Text {
    visible: !root.dynamic && Appearance.State.wallpaperPath !== ""
    x: parent.width - 190; y: 0; width: 124; height: 64
    text: Appearance.State.wallpaperName
    elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter
    font.family: Shell.Theme.fontFamily; font.pixelSize: 13; color: Shell.Theme.palette.foregroundMuted
  }
  Image {
    visible: !root.dynamic && Appearance.State.wallpaperPath !== ""
    x: parent.width - 56; y: 19; width: 40; height: 26
    source: Appearance.State.wallpaperUrl
    sourceSize: Qt.size(Math.ceil(width * Screen.devicePixelRatio), Math.ceil(height * Screen.devicePixelRatio))
    fillMode: Image.PreserveAspectCrop; asynchronous: true
  }
  HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
  TapHandler { onTapped: root.clicked() }
}
