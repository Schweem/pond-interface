import QtQuick

// Marsh after dark: the same paper, ink and accents, turned for a dark
// screen. Ink is the ground, cards lift a step off it, slate draws the 1px
// lines and paper the text. Chartreuse still marks whatever is active, with
// ink drawn on top of it.
ThemePalette {
  id: root
  readonly property color paper: "#E1EBF7"
  readonly property color ink: "#111111"
  readonly property color slate: "#4C5164"
  readonly property color mist: "#9BA7B5"
  readonly property color dusk: "#6B7385"
  readonly property color chartreuse: "#CEF058"
  readonly property color yellow: "#FFD330"
  readonly property color lilac: "#CBA6F7"
  readonly property color orange: "#FF9F67"
  readonly property color brown: "#4F220C"
  readonly property color rose: "#FA6D80"
  // Cards and panels, a step up from the ink ground.
  readonly property color raised: Qt.tint(root.ink, Qt.alpha(root.paper, 0.05))

  label: "Night Marsh"
  blur: false
  dimWallpaper: false
  wallpaperColor: root.ink
  wallpaperGrid: Qt.alpha(root.paper, 0.06)
  uniformCards: true
  dragPreview: true

  cardBorderWidth: 1
  compactCardRadius: 12
  idleIconOpacity: 1.0
  collapseDuration: 200
  launcherTheme: "night-marsh"

  cardFill: root.raised
  cardHoverFill: Qt.tint(root.raised, Qt.alpha(root.paper, 0.04))
  cardOutline: root.slate
  hoverFill: Qt.alpha(root.paper, 0.06)
  innerOutline: root.slate
  track: Qt.alpha(root.paper, 0.2)
  actionSelected: root.chartreuse
  actionHover: Qt.alpha(root.paper, 0.06)
  actionIdle: Qt.alpha(root.paper, 0)
  previewFill: Qt.alpha(root.paper, 0.04)
  previewHoverFill: Qt.alpha(root.paper, 0.08)

  workspaceLauncherActive: root.chartreuse
  workspaceActiveIndicatorColor: root.chartreuse
  workspaceIconOutline: root.slate
  workspaceControlHover: Qt.alpha(root.paper, 0.08)
  workspacePlaceholderColor: Qt.alpha(root.paper, 0.3)
  workspaceNumberBackground: root.paper
  workspaceNumberDragBackground: root.mist
  workspaceNumberText: root.ink
  workspaceDragBackground: root.yellow
  workspaceDragGlyphScale: 13.913043975830078 / 16
  dropStroke: root.mist
  dropFill: Qt.alpha(root.paper, 0.06)
  dropDashed: true

  surface: root.raised
  surfaceBorder: root.slate
  divider: root.slate
  control: Qt.alpha(root.paper, 0.08)
  foreground: root.paper
  foregroundBright: root.paper
  foregroundSecondary: root.mist
  iconTint: root.paper
  onAccent: root.ink
  mediaHover: Qt.tint(root.raised, Qt.alpha(root.paper, 0.04))
  subtleFill: Qt.alpha(root.paper, 0.06)

  panelSurface: root.raised
  panelBackSurface: root.ink
  panelBorder: root.slate
  panelBorderWidth: 1
  panelHover: Qt.alpha(root.paper, 0.06)
  panelPressed: Qt.alpha(root.paper, 0.12)
  panelDivider: root.slate
  panelTrack: Qt.alpha(root.paper, 0.15)
  buttonHover: Qt.alpha(root.paper, 0.2)
  connectedRow: root.chartreuse
  checkMark: root.ink
  overlay: root.paper
  shadows: false
  enabledSurface: root.chartreuse
  enabledMark: root.ink
  disabledSurface: root.brown
  disabledMark: root.orange
  toggleOutline: root.mist
  sliderFill: root.paper
  sliderBubble: root.yellow
  sliderBubbleText: root.ink
  todayFill: root.lilac
  todayText: root.ink
  closeCompact: root.slate
  closeFill: root.lilac
  closeHoverFill: Qt.lighter(root.lilac, 1.08)

  settingsOverlay: root.ink
  settingsCard: root.raised
  settingsHover: Qt.tint(root.raised, Qt.alpha(root.paper, 0.06))
  settingsBorderWidth: 1
  sessionControl: Qt.tint(root.raised, Qt.alpha(root.paper, 0.08))
  foregroundMuted: root.mist
  foregroundFaint: root.dusk
  controlFill: Qt.alpha(root.paper, 0.05)
  controlHover: Qt.alpha(root.paper, 0.10)
  controlBorder: root.slate
  controlBorderHover: root.mist
  controlSelected: Qt.alpha(root.lilac, 0.2)
  controlRaised: Qt.alpha(root.paper, 0.15)
  accentSurface: Qt.alpha(root.lilac, 0.25)
  outlineStrong: root.mist
  outlineSubtle: root.slate
  sliderMark: root.paper
  errorText: root.rose
  selectionFill: root.lilac
  selectionText: root.ink
  sliderHandle: root.yellow
  // Warnings sit on a tint of their color, not a full fill, after dark.
  lowColors: [root.yellow, root.orange, root.rose]
  lowSurfaces: [Qt.tint(root.raised, Qt.alpha(root.yellow, 0.15)),
      Qt.tint(root.raised, Qt.alpha(root.orange, 0.15)), Qt.tint(root.raised, Qt.alpha(root.rose, 0.15))]
  placeholderBorder: root.slate
  placeholderHover: Qt.alpha(root.paper, 0.05)
  placeholderGlyph: root.slate
  themeTileIdle: Qt.tint(root.raised, Qt.alpha(root.paper, 0.08))
  themeLabel: root.paper
  transitionFill: root.chartreuse
  transitionEdge: root.ink
}
