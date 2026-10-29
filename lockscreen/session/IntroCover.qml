import QtQuick

// One lock surface's cells for Intro, laid out exactly as the shell's cover
// on the same screen so the handoff shows no seam.
Item {
    id: root

    required property var intro
    required property var screen
    readonly property bool active: intro.phase !== "off"
    // Fixed for the whole opening so the grid never shifts mid-wave.
    readonly property var grid: intro.layout(width, height, intro.originOn(screen, width, height))
    readonly property int size: intro.cellSize

    visible: active

    Repeater {
        model: root.active && root.width > 0 ? root.grid.cols * root.grid.rows : 0

        Rectangle {
            required property int index
            readonly property int i: index % root.grid.cols - root.grid.left
            readonly property int j: Math.floor(index / root.grid.cols) - root.grid.top
            readonly property int ring: root.intro.ring(i, j)
            // One pixel wider so neighbours share a single edge line.
            x: root.grid.x - root.size / 2 + i * root.size
            y: root.grid.y - root.size / 2 + j * root.size
            width: root.size + 1
            height: width
            visible: root.intro.phase === "held" || ring >= root.intro.step
            color: root.intro.request?.fill ?? "transparent"
            border.width: 1
            border.color: root.intro.request?.edge ?? "transparent"
            antialiasing: false
        }
    }
}
