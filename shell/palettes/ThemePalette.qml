import QtQuick

// Everything that differs between themes. Each theme in this directory
// instantiates a ThemePalette and sets every property.
QtObject {
  property string label

  // Blur the wallpaper behind sidebar cards and feedback popups.
  property bool blur
  // Shade the wallpaper behind the sidebar.
  property bool dimWallpaper
  // Cards use cardFill rather than their own classicColor.
  property bool uniformCards
  // Window drags reveal workspace numbers and placeholders, preview the drop
  // slot, and lift the icon with panel shadows.
  property bool dragPreview

  property int cardBorderWidth
  property int compactCardRadius
  property real idleIconOpacity

  property color cardFill
  property color cardHoverFill
  property color cardOutline
  property color hoverFill
  property color innerOutline
  property color track
  property color actionSelected
  property color actionHover
  property color actionIdle
  property color previewFill
  property color previewHoverFill

  property color workspaceLauncherActive
  property color workspaceActiveIndicatorColor
  property color workspaceIconOutline
  property color workspaceControlHover
  property color workspacePlaceholderColor
  property color workspaceNumberBackground
  property color workspaceNumberDragBackground
  property color workspaceNumberText
  property color workspaceDragBackground
  property real workspaceDragGlyphScale
  property color dropStroke
  property color dropFill
  property bool dropDashed
}
