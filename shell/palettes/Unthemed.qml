import QtQuick

ThemePalette {
  id: root
  label: "Unthemed"
  blur: false
  dimWallpaper: false
  uniformCards: false
  dragPreview: false

  cardBorderWidth: 0
  compactCardRadius: 16
  idleIconOpacity: 0.9

  cardFill: "#1D1D1D"
  cardHoverFill: root.cardFill
  cardOutline: Qt.rgba(1, 1, 1, 0.10)
  hoverFill: "#262626"
  innerOutline: "#303030"
  track: "#3D3D3D"
  actionSelected: "#303030"
  actionHover: "#262626"
  actionIdle: Qt.rgba(38/255, 38/255, 38/255, 0)
  previewFill: "#242424"
  previewHoverFill: "#313131"

  workspaceLauncherActive: "#262626"
  workspaceActiveIndicatorColor: "#262626"
  workspaceIconOutline: root.innerOutline
  workspaceControlHover: "#303030"
  workspacePlaceholderColor: root.innerOutline
  workspaceNumberBackground: "#242424"
  workspaceNumberDragBackground: "#303030"
  workspaceNumberText: "#F8F9F9"
  workspaceDragBackground: "#292929"
  workspaceDragGlyphScale: 1
  dropStroke: "#4F3D64"
  dropFill: "#191919"
  dropDashed: true
}
