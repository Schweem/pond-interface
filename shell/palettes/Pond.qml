import QtQuick

// Flat paper and ink, after butterfly.so: pale blue fills, 1px ink lines,
// chartreuse for whatever is active.
ThemePalette {
  id: root
  readonly property color paper: "#E1EBF7"
  readonly property color ink: "#111111"
  readonly property color slate: "#4C5164"
  readonly property color chartreuse: "#CEF058"
  readonly property color yellow: "#FFD330"
  readonly property color lilac: "#CBA6F7"
  readonly property color orange: "#FF9F67"
  readonly property color brown: "#4F220C"

  label: "Pond"
  blur: false
  dimWallpaper: false
  wallpaperColor: root.paper
  wallpaperGrid: Qt.alpha(root.ink, 0.08)
  uniformCards: true
  dragPreview: true

  cardBorderWidth: 1
  compactCardRadius: 12
  idleIconOpacity: 1.0
  collapseDuration: 200
  launcherTheme: "pond"

  cardFill: root.paper
  cardHoverFill: Qt.tint(root.paper, Qt.alpha(root.ink, 0.04))
  cardOutline: root.ink
  hoverFill: Qt.alpha(root.ink, 0.06)
  innerOutline: root.ink
  track: Qt.alpha(root.ink, 0.2)
  actionSelected: root.chartreuse
  actionHover: Qt.alpha(root.ink, 0.06)
  actionIdle: Qt.alpha(root.ink, 0)
  previewFill: Qt.alpha(root.ink, 0.04)
  previewHoverFill: Qt.alpha(root.ink, 0.08)

  workspaceLauncherActive: root.chartreuse
  workspaceActiveIndicatorColor: root.chartreuse
  workspaceIconOutline: root.ink
  workspaceControlHover: Qt.alpha(root.ink, 0.08)
  workspacePlaceholderColor: Qt.alpha(root.ink, 0.3)
  workspaceNumberBackground: root.ink
  workspaceNumberDragBackground: root.slate
  workspaceNumberText: root.paper
  workspaceDragBackground: root.yellow
  workspaceDragGlyphScale: 13.913043975830078 / 16
  dropStroke: root.ink
  dropFill: Qt.alpha(root.ink, 0.06)
  dropDashed: true

  surface: root.paper
  surfaceBorder: "#9BA7B5"
  divider: root.ink
  control: Qt.alpha(root.ink, 0.08)
  foreground: root.ink
  foregroundBright: root.ink
  foregroundSecondary: root.slate
  iconTint: root.ink
  mediaHover: Qt.tint(root.paper, Qt.alpha(root.ink, 0.04))
  subtleFill: Qt.alpha(root.ink, 0.06)

  panelSurface: root.paper
  panelBackSurface: "#CDD9E8"
  panelBorder: root.ink
  panelBorderWidth: 1
  panelHover: Qt.alpha(root.ink, 0.06)
  panelPressed: Qt.alpha(root.ink, 0.12)
  panelDivider: root.ink
  panelTrack: Qt.alpha(root.ink, 0.15)
  buttonHover: Qt.alpha(root.ink, 0.2)
  connectedRow: root.chartreuse
  checkMark: root.paper
  overlay: root.ink
  shadows: false
  enabledSurface: root.ink
  enabledMark: root.chartreuse
  disabledSurface: root.brown
  disabledMark: root.orange
  toggleOutline: root.ink
  sliderFill: root.ink
  sliderBubble: root.yellow
  sliderBubbleText: root.ink
  todayFill: root.lilac
  todayText: root.ink
  closeCompact: "#9BA7B5"
  closeFill: root.lilac
  closeHoverFill: Qt.lighter(root.lilac, 1.08)

  settingsOverlay: "#9BA7B5"
  settingsCard: root.paper
  settingsHover: Qt.tint(root.paper, Qt.alpha(root.ink, 0.06))
  settingsBorderWidth: 1
  sessionControl: Qt.tint(root.paper, Qt.alpha(root.ink, 0.08))
  foregroundMuted: root.slate
  foregroundFaint: "#6B7385"
  controlFill: Qt.alpha(root.ink, 0.05)
  controlHover: Qt.alpha(root.ink, 0.10)
  controlBorder: root.ink
  controlBorderHover: root.ink
  controlSelected: Qt.alpha(root.lilac, 0.25)
  controlRaised: Qt.alpha(root.ink, 0.15)
  accentSurface: Qt.alpha(root.lilac, 0.3)
  outlineStrong: root.ink
  outlineSubtle: Qt.alpha(root.ink, 0.3)
  sliderMark: root.ink
  errorText: "#C4314B"
  selectionFill: root.lilac
  selectionText: root.ink
  sliderHandle: root.yellow
  lowColors: [root.yellow, root.orange, "#FA6D80"]
  lowSurfaces: [root.yellow, root.orange, "#FA6D80"]
  lowInkText: true
  lowBannerOpacity: 1
  placeholderBorder: "#9BA7B5"
  placeholderHover: Qt.alpha(root.ink, 0.05)
  placeholderGlyph: "#9BA7B5"
  themeTileIdle: Qt.tint(root.paper, Qt.alpha(root.ink, 0.08))
  themeLabel: root.ink
  transitionFill: root.chartreuse
  transitionEdge: root.ink
}
