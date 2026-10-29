import QtQuick

// Everything that differs between themes. Each theme in this directory
// instantiates a ThemePalette; properties with a default here are shared by
// the dark themes and only need setting when a theme departs from them.
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

  property color surface: "#1D1D1D"
  property color surfaceBorder: "#303030"
  property color divider: "#383838"
  property color control: "#303030"
  property color foreground: "#F8F9F9"
  property color foregroundBright: "white"
  property color foregroundSecondary: "#B7B7B7"
  property color iconTint: "white"
  property color mediaHover: "#262626"
  property color subtleFill: Qt.rgba(1, 1, 1, 0.08)
}
