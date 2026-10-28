import QtQuick

ThemePalette {
  id: root
  label: "Daylight"
  blur: true
  dimWallpaper: true
  uniformCards: true
  dragPreview: true

  cardBorderWidth: 1
  compactCardRadius: 12
  idleIconOpacity: 1.0

  cardFill: Qt.rgba(0, 0, 0, 0.10)
  cardHoverFill: Qt.tint(root.cardFill, root.hoverFill)
  cardOutline: Qt.rgba(1, 1, 1, 0.10)
  hoverFill: Qt.rgba(1, 1, 1, 0.04)
  innerOutline: Qt.rgba(1, 1, 1, 0.20)
  track: root.innerOutline
  actionSelected: root.hoverFill
  actionHover: root.hoverFill
  actionIdle: Qt.rgba(1, 1, 1, 0)
  previewFill: Qt.tint(root.hoverFill, Qt.rgba(1, 1, 1, 0))
  previewHoverFill: Qt.tint(root.hoverFill, root.hoverFill)

  workspaceLauncherActive: root.hoverFill
  workspaceActiveIndicatorColor: root.hoverFill
  workspaceIconOutline: root.cardOutline
  workspaceControlHover: Qt.rgba(1, 1, 1, 0.10)
  workspacePlaceholderColor: Qt.rgba(1, 1, 1, 0.30)
  workspaceNumberBackground: "#5B5B5B"
  workspaceNumberDragBackground: "#787878"
  workspaceNumberText: "white"
  workspaceDragBackground: "#53525D"
  workspaceDragGlyphScale: 13.913043975830078 / 16
  dropStroke: Qt.rgba(1, 1, 1, 0.20)
  dropFill: Qt.rgba(1, 1, 1, 0.20)
  dropDashed: false
}
