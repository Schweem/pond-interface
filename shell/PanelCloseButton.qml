import QtQuick

Item {
  id: root
  signal clicked
  implicitWidth: 40
  implicitHeight: 40

  Rectangle {
    anchors.fill: parent
    radius: 12
    color: closeHover.hovered ? Theme.palette.closeHoverFill : Theme.palette.closeFill
    border.color: PanelStyle.border
    border.width: Theme.palette.panelBorderWidth
    antialiasing: true

    Glyph {
      anchors.centerIn: parent
      width: 20
      height: 20
      source: Qt.resolvedUrl("assets/wifi/close.svg")
    }
  }

  HoverHandler { id: closeHover; cursorShape: Qt.PointingHandCursor }
  TapHandler { onTapped: root.clicked() }
}
