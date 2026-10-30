pragma ComponentBehavior: Bound
import QtQuick
import "Glyphs.js" as Glyphs

Item {
    id: root
    required property var theme
    property bool restartEnabled: false
    property bool expanded: false
    readonly property bool restartShown: expanded && restartEnabled && enabled
    signal shutdownRequested
    signal restartRequested

    width: 80
    height: restartShown ? 160 : 80
    onEnabledChanged: { if (!enabled) expanded = false; }
    onRestartEnabledChanged: { if (!restartEnabled) expanded = false; }

    // A single hover region joins both rows, without an exit/enter gap.
    HoverHandler {
        onHoveredChanged: { if (!hovered) root.expanded = false; }
    }

    component ActionButton: Rectangle {
        id: action
        required property string label
        required property var glyph
        readonly property bool hovered: mouse.containsMouse && enabled
        signal clicked
        width: 80
        height: 80
        color: hovered ? root.theme.accent : root.theme.paper
        border.color: root.theme.ink
        border.width: 2

        Glyph {
            objectName: action.objectName + "Icon"
            anchors.fill: parent
            glyph: action.glyph
            color: action.hovered ? root.theme.onAccent : root.theme.ink
        }
        Rectangle {
            x: -10 - width
            y: 26
            width: labelText.implicitWidth + 16
            height: 28
            color: root.theme.ink
            opacity: action.hovered ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 120 } }
            Text {
                id: labelText
                objectName: action.objectName + "Label"
                anchors.centerIn: parent
                text: action.label
                color: root.theme.paper
                font.family: root.theme.monoFont
                font.weight: Font.DemiBold
                font.pixelSize: 11
                font.letterSpacing: 2
            }
        }
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: action.clicked()
        }
    }

    ActionButton {
        objectName: "shutdownButton"
        label: "SHUT DOWN"
        glyph: Glyphs.power
        onHoveredChanged: { if (hovered && root.restartEnabled) root.expanded = true; }
        onClicked: root.shutdownRequested()
    }
    ActionButton {
        objectName: "restartButton"
        y: 78
        label: "RESTART"
        glyph: Glyphs.restart
        enabled: root.restartShown
        opacity: root.restartShown ? 1 : 0
        visible: root.restartShown || opacity > 0
        Behavior on opacity { NumberAnimation { duration: 120 } }
        onClicked: root.restartRequested()
    }
}
