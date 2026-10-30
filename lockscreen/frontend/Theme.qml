import QtQuick

// The lock screen's colors, by palette name. The session lock follows the
// shell's theme.json; the greeter can't read it and stays on the default.
// A palette without a lock screen of its own falls back to Marsh.
QtObject {
    id: root
    property string name: "marsh"

    readonly property var palettes: ({
        marsh: {
            paper: "#E1EBF7",
            ink: "#111111",
            slate: "#4C5164",
            muted: "#9BA7B5",
            accent: "#CEF058",
            water: "#CEF058",
            error: "#FA6D80"
        }
    })
    readonly property var palette: palettes[name] ?? palettes.marsh

    readonly property color paper: palette.paper
    readonly property color ink: palette.ink
    readonly property color slate: palette.slate
    readonly property color muted: palette.muted
    // Whatever is active: typed cells, success, hovered controls.
    readonly property color accent: palette.accent
    readonly property color water: palette.water
    readonly property color error: palette.error

    readonly property string displayFont: "Pond Gramercy"
    readonly property string uiFont: "Onest"
    // Bundled (with its OFL license) so the labels never depend on the system;
    // loading each weight registers it under the one family name.
    readonly property string monoFont: monoRegular.name || "IBM Plex Mono"
    readonly property FontLoader monoRegular: FontLoader { source: Qt.resolvedUrl("fonts/IBMPlexMono-Regular.ttf") }
    readonly property FontLoader monoMedium: FontLoader { source: Qt.resolvedUrl("fonts/IBMPlexMono-Medium.ttf") }
    readonly property FontLoader monoSemiBold: FontLoader { source: Qt.resolvedUrl("fonts/IBMPlexMono-SemiBold.ttf") }
}
