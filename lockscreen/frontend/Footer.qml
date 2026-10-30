pragma ComponentBehavior: Bound
import QtQuick

// The pre-release notice in the bottom-right corner, on screens wide enough
// to keep it clear of the reeds.
Item {
    id: root
    required property var theme
    readonly property bool wide: width >= 1280

    // Bar widths for the notice's code mark; decoration, fixed so it never shifts.
    readonly property var bars: [2, 1, 3, 1, 1, 2, 4, 2, 1, 1, 3, 2, 1, 4, 1, 2, 2, 1, 3, 1, 1, 2]

    Rectangle {
        x: root.width - 24 - width
        y: root.height - 24 - height
        width: 376
        height: 52
        visible: root.wide
        color: root.theme.paper
        border.color: root.theme.ink
        border.width: 1
        Text {
            x: 14
            anchors.verticalCenter: parent.verticalCenter
            text: "SOME FEATURES MAY NOT WORK AS EXPECTED.\nPLEASE REPORT ANY ISSUES OR BUGS."
            color: root.theme.ink
            lineHeight: 1.4
            font.family: root.theme.monoFont
            font.weight: Font.Medium
            font.pixelSize: 10
            font.letterSpacing: 0.5
        }
        Row {
            x: parent.width - 14 - width
            y: 8
            height: 36
            spacing: 2
            Repeater {
                model: root.bars
                Rectangle {
                    required property int modelData
                    required property int index
                    width: modelData
                    height: 36
                    color: index % 3 === 2 ? "transparent" : root.theme.ink
                }
            }
        }
    }
}
