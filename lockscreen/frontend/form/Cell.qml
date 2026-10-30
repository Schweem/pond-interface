import QtQuick
import ".."
import "../Glyphs.js" as Glyphs

Item {
    id: root

    required property var theme
    required property var visual

    width: 80
    height: 80
    opacity: visual.mode === "hidden" ? 0 : 1

    function isShapeMode() {
        return visual.mode === "shape" || visual.mode === "delete";
    }

    Rectangle {
        anchors.fill: parent
        color: {
            const mode = root.visual.mode;
            if (mode === "caretOn" || mode === "caretEnter")
                return root.theme.ink;
            if (mode === "shape" || mode === "successFill")
                return root.theme.accent;
            if (mode === "delete" || mode === "errorFill")
                return root.theme.error;
            // Idle cells are paper so the sighting rule passes behind them;
            // outlines stay open over whatever the reveal uncovers.
            if (mode === "empty" || mode === "caretOff" || mode === "idleDot")
                return root.theme.paper;
            return "transparent";
        }
        // Shared edges are drawn once by CellGrid.
        border.width: 0
    }

    Glyph {
        anchors.centerIn: parent
        width: root.visual.shape === 0 ? 36 : 80
        height: width
        glyph: Glyphs.shapes[Math.max(0, Math.min(3, root.visual.shape))]
        color: root.theme.ink
        visible: root.isShapeMode()
    }

    Glyph {
        objectName: "enterBlinker"
        anchors.centerIn: parent
        width: 27
        height: 27
        glyph: Glyphs.enter
        color: root.theme.accent
        cutColor: root.theme.ink
        visible: root.visual.mode === "caretEnter"
    }

    Rectangle {
        width: 10
        height: 10
        radius: 5
        anchors.centerIn: parent
        color: root.visual.mode === "caretOn" ? root.theme.accent : root.theme.ink
        visible: root.visual.mode === "idleDot" || root.visual.mode === "caretOn" || root.visual.mode === "caretOff"
    }

    Behavior on opacity { NumberAnimation { duration: 45 } }
}
