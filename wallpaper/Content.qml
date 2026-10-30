import QtQuick

Rectangle {
  id: root
  property bool custom: false
  property bool dimmed: false
  property url imageSource: ""
  // The solid color under the grid; transparent falls back to the base.
  property color plainColor: "transparent"
  // Dashed grid over the plain color; transparent draws none.
  property alias gridColor: grid.color
  property alias gridSpacing: grid.spacing
  color: root.plainColor.a > 0 ? root.plainColor : "#0b101c"
  layer.enabled: root.dimmed
  layer.format: ShaderEffectSource.RGBA16F

  DashGrid {
    id: grid
    anchors.fill: parent
    visible: !root.custom
  }
  Image {
    objectName: "wallpaperImage"
    anchors.fill: parent
    source: root.custom ? root.imageSource : ""
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
  }
  Rectangle {
    visible: root.dimmed
    width: parent.width * 788 / 1728
    height: parent.height
    gradient: Gradient {
      orientation: Gradient.Horizontal
      GradientStop { position: 0; color: Qt.rgba(0, 0, 0, 0.4) }
      GradientStop { position: 1; color: Qt.rgba(0, 0, 0, 0) }
    }
  }
}
