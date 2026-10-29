import QtQuick
import Quickshell

// The lock's opening when the shell hands over a cover: every screen starts
// under the same cells the shell covered it with, matched cell for cell, and
// they clear in rings once the lock screen has drawn underneath. Mirrors the
// shell's ScreenTransition; IntroCover draws each screen's cells.
Item {
    id: root

    // { fill, edge, screen, x, y } from lockFrom, or null to open plainly.
    property var request: null
    readonly property int cellSize: 80
    readonly property int duration: 500
    // Clears anyway after this, in case a screen never draws.
    readonly property int readyTimeout: 3000
    // "off" | "held" | "clear"
    property string phase: "off"
    property int step: 0
    property int maxRing: 0
    property int interval: 28
    property var readyScreens: ({})

    function originOn(screen, width, height) {
        return request && request.screen === screen.name
            ? Qt.point(request.x, request.y) : Qt.point(width / 2, height / 2);
    }

    // Diamond rings: grid steps away from the origin cell.
    function ring(i, j) { return Math.abs(i) + Math.abs(j); }

    // Cell grid for a screen, laid out so one cell is centered on the origin.
    function layout(width, height, point) {
        const size = cellSize;
        const left = Math.ceil((point.x - size / 2) / size);
        const top = Math.ceil((point.y - size / 2) / size);
        const cols = left + Math.ceil((width - point.x - size / 2) / size) + 1;
        const rows = top + Math.ceil((height - point.y - size / 2) / size) + 1;
        const far = Math.max(ring(left, top), ring(cols - 1 - left, top),
                             ring(left, rows - 1 - top), ring(cols - 1 - left, rows - 1 - top));
        return { x: point.x, y: point.y, left, top, cols, rows, far };
    }

    // A screen has drawn its lock screen under the cells.
    function setReady(name) {
        if (phase !== "held" || readyScreens[name])
            return;
        const screens = Object.assign({}, readyScreens);
        screens[name] = true;
        readyScreens = screens;
        if (Quickshell.screens.every(screen => readyScreens[screen.name]))
            clear();
    }

    function clear() {
        if (phase !== "held")
            return;
        step = 0;
        phase = "clear";
    }

    Component.onCompleted: {
        if (!request)
            return;
        let far = 0;
        for (const screen of Quickshell.screens)
            far = Math.max(far, layout(screen.width, screen.height,
                                       originOn(screen, screen.width, screen.height)).far);
        maxRing = far;
        interval = Math.max(16, Math.round(duration / Math.max(1, far)));
        phase = "held";
    }

    Timer {
        interval: root.interval
        repeat: true
        running: root.phase === "clear"
        onTriggered: {
            if (root.step <= root.maxRing)
                root.step++;
            else
                root.phase = "off";
        }
    }

    Timer {
        interval: root.readyTimeout
        running: root.phase === "held"
        onTriggered: root.clear()
    }
}
