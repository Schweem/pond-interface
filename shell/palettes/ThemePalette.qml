import QtQuick

// Everything that differs between themes. Each theme in this directory
// instantiates a ThemePalette; properties with a default here are shared by
// the dark themes and only need setting when a theme departs from them.
QtObject {
  id: root
  property string label

  // Blur the wallpaper behind sidebar cards and feedback popups.
  property bool blur
  // Shade the wallpaper behind the sidebar.
  property bool dimWallpaper
  // Solid wallpaper in place of the dynamic sky; transparent keeps the sky.
  property color wallpaperColor: "transparent"
  // Dashed grid over the solid wallpaper; transparent draws none.
  property color wallpaperGrid: "transparent"
  // Cards use cardFill rather than their own classicColor.
  property bool uniformCards
  // Window drags reveal workspace numbers and placeholders, preview the drop
  // slot, and lift the icon with panel shadows.
  property bool dragPreview

  property int cardBorderWidth
  property int compactCardRadius
  property real idleIconOpacity
  // Sidebar expand/collapse, in milliseconds.
  property int collapseDuration: 300
  // Vicinae theme (by file name) set alongside this one.
  property string launcherTheme: "default"

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

  // Popover panels (PanelStyle) and the notification center.
  property color panelSurface: "#1D1D1D"
  property color panelBackSurface: "#131313"
  property color panelBorder: "#3D3D3D"
  property color panelHover: "#262626"
  property color panelPressed: "#303030"
  property color panelDivider: Qt.rgba(1, 1, 1, 0.1)
  property color accent: "#CBA6F7"
  property color accentText: "#4F3D64"
  property color enabledSurface: "#0C3723"
  property color enabledMark: "#B0FF4F"
  property color sliderFill: "#E7E7E7"
  property color sliderBubble: "#D1D1D1"
  property bool shadows: true
  property color overlay: "white"
  property color accentHover: "#D8B8FA"
  property color toggleOutline: Qt.rgba(231 / 255, 231 / 255, 231 / 255, 0.3)
  property color disabledSurface: "#613129"
  property color disabledMark: "#FB9B89"
  property color sliderBubbleText: "black"
  property color todayFill: "#D1C9FF"
  property color todayText: "#643957"
  property color closeCompact: "#555555"
  property real panelBorderWidth: 0.5
  property color buttonHover: "#3D3D3D"
  property color panelTrack: "#3D3D3D"
  property color connectedRow: "transparent"
  property color checkMark: "black"
  property color closeFill: root.panelHover
  property color closeHoverFill: root.panelPressed

  // Settings window.
  property color settingsOverlay: "#101010"
  property color settingsCard: "#1D1D1D"
  property color settingsHover: "#262626"
  property color sessionControl: "#2C2C2C"
  property color foregroundMuted: "#B3B3B3"
  property color foregroundFaint: "#777777"
  property color controlFill: "#262626"
  property color controlHover: "#303030"
  property color controlBorder: "#303030"
  property color controlBorderHover: "#444444"
  property color controlSelected: "#333333"
  property color controlRaised: "#525252"
  property color accentSurface: "#3F3847"
  property color outlineStrong: "#4A4A4A"
  property color outlineSubtle: "#343434"
  property color sliderMark: "#D9D9D9"
  property color errorText: "#FFB4AB"
  property real settingsBorderWidth: 0
  property color selectionFill: "#4F3D64"
  property color selectionText: "white"
  property color sliderHandle: root.sliderFill

  // Low battery, from warning (10%) to severe (5%) to critical (3%).
  property var lowColors: ["#FFDC67", "#FF9F67", "#FD6164"]
  property var lowSurfaces: ["#343024", "#342A24", "#3E2222"]
  // Draw warning text in the foreground color on a filled warning surface.
  property bool lowInkText: false
  property real lowBannerOpacity: 0.1

  // Unavailable ("coming soon") theme tile in the appearance picker.
  property color placeholderBorder: "#262626"
  property color placeholderHover: "#171717"
  property color placeholderGlyph: "#262626"
  // Theme picker: idle tile disc and the current theme's name.
  property color themeTileIdle: "#262626"
  property color themeLabel: root.accent

  // Cells that hide a switch into this theme (ThemeSwitchTransition), and that
  // cover the screen while it powers off.
  property color transitionFill: root.accent
  property color transitionEdge: "#1D1D1D"
}
