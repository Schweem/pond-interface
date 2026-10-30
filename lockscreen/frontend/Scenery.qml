pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes

// The lock screen's backdrop, in canvas units: paper above a waterline,
// hatched water below, reeds on both banks. The unlock reveal samples it, so
// everything here stays put in each quadrant until that quadrant opens.
Item {
    id: root
    required property var theme
    // Where the cell grid centres; the sighting rule runs through it.
    property real gridCenterY: 520
    readonly property real horizon: 900

    // Before the window has a size the canvas can be zero or infinitely wide.
    function count(n) { return isFinite(n) && n > 0 ? n : 0; }

    Rectangle {
        anchors.fill: parent
        color: root.theme.paper
    }

    // Sighting rule through the grid, ticked every 40.
    Shape {
        y: root.gridCenterY
        width: root.width
        height: 1
        opacity: 0.35
        ShapePath {
            strokeColor: root.theme.ink
            strokeWidth: 1
            strokeStyle: ShapePath.DashLine
            dashPattern: [1, 5]
            fillColor: "transparent"
            startX: 0; startY: 0.5
            PathLine { x: root.width; y: 0.5 }
        }
    }
    Repeater {
        model: root.count(Math.ceil(root.width / 40))
        Rectangle {
            required property int index
            x: index * 40
            y: root.gridCenterY - 4
            width: 1
            height: 8
            color: root.theme.ink
            opacity: 0.5
        }
    }

    // Registration marks at the corners of the grid's square.
    Repeater {
        model: [[-240, -240], [240, -240], [-240, 240], [240, 240]]
        Item {
            required property var modelData
            x: root.width / 2 + modelData[0] - 10
            y: root.gridCenterY + modelData[1] - 10
            width: 20
            height: 20
            Rectangle { x: 4.5; y: 4.5; width: 11; height: 11; radius: 5.5; color: "transparent"; border.color: root.theme.ink; border.width: 1 }
            Rectangle { y: 9.5; width: 20; height: 1; color: root.theme.ink }
            Rectangle { x: 9.5; width: 1; height: 20; color: root.theme.ink }
        }
    }

    Rectangle {
        y: root.horizon
        width: root.width
        height: root.height - y
        color: root.theme.water
    }
    // Hatching: dashes lengthen and close up toward the bottom edge.
    Repeater {
        model: root.count(Math.floor((root.height - root.horizon - 10) / 9) + 1)
        Shape {
            id: row
            required property int index
            readonly property real lineWidth: 1 + index * 0.05
            y: root.horizon + 10 + index * 9
            width: root.width
            height: 1
            ShapePath {
                strokeColor: root.theme.ink
                strokeWidth: row.lineWidth
                strokeStyle: ShapePath.DashLine
                dashPattern: [(30 + row.index * 6) / row.lineWidth, Math.max(1, 18 - row.index * 0.7) / row.lineWidth]
                dashOffset: row.index * 37 / row.lineWidth
                fillColor: "transparent"
                startX: 0; startY: 0
                PathLine { x: root.width; y: 0 }
            }
        }
    }

    // Station ruler along the waterline.
    Repeater {
        model: root.count(Math.ceil(root.width / 96) + 1)
        Item {
            required property int index
            x: index * 96
            y: root.horizon - 10
            Rectangle { width: 1; height: 10; color: root.theme.ink }
            Text {
                x: 4
                y: -1
                text: String(parent.index).padStart(2, "0")
                color: root.theme.slate
                font.family: root.theme.monoFont
                font.pixelSize: 9
            }
        }
    }
    Rectangle {
        y: root.horizon - 1.5
        width: root.width
        height: 3
        color: root.theme.ink
    }

    // Each bank keeps clear of the widest (21-cell) grid.
    Reeds {
        x: Math.min(0, root.width / 2 - 340 - width)
        y: root.horizon + 30 - 270
        color: root.theme.ink
    }
    Reeds {
        x: Math.max(root.width - width, root.width / 2 + 340)
        y: root.horizon + 30 - 270
        rightBank: true
        color: root.theme.ink
    }
}
