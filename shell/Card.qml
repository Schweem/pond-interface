import QtQuick
import Quickshell

Rectangle {
  id: root
  default property alias contentData: content.data
  property bool contentClipped: true
  property color classicColor: Theme.palette.surface
  property bool animateClassicColor: false
  readonly property bool cardHovered: cardHover.hovered
  readonly property Region blurRegion: Region {
    item: root
    radius: root.radius
  }
  color: Theme.palette.uniformCards
      ? (cardHovered ? Theme.palette.cardHoverFill : Theme.palette.cardFill) : classicColor
  border.width: Theme.palette.cardBorderWidth
  border.color: Theme.palette.cardOutline
  radius: Theme.sidebarCardRadius
  antialiasing: true
  // Clip the contents without cutting off the outline's antialiasing.
  data: Item {
    id: content
    anchors.fill: parent
    clip: root.contentClipped
  }
  HoverHandler { id: cardHover }
  Behavior on color {
    enabled: Theme.palette.uniformCards || animateClassicColor
    ColorAnimation { duration: 120; easing.type: Easing.OutCubic }
  }
}
