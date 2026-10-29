pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Pond.WifiStatus

ShellRoot {
    id: root

    readonly property Session session: locker.item as Session

    // The shell's cover to open under, for the next lock only.
    property var introRequest: null

    function lock() { locker.active = true; }
    function lockFrom(request) {
        if (!locker.active)
            introRequest = request;
        lock();
    }
    function lockAndSuspend() {
        lock();
        suspendWait.checks = 0;
        suspendWait.restart();
    }
    Component.onCompleted: {
        // Reloading a secure lock must never destroy its authentication state.
        Quickshell.watchFiles = false;
        if (Quickshell.env("POND_LOCK_NO_START") !== "1")
            lock();
    }

    SessionInfo { id: info }
    NetworkStatus { id: network }
    QtObject {
        id: power
        function shutdown() { Quickshell.execDetached(["/usr/bin/systemctl", "poweroff"]); }
        function reboot() { Quickshell.execDetached(["/usr/bin/systemctl", "reboot"]); }
        function suspend() { Quickshell.execDetached(["/usr/bin/systemctl", "suspend"]); }
    }
    Loader {
        id: locker
        active: false
        onActiveChanged: if (!active) root.introRequest = null
        sourceComponent: Session {
            displayName: info.displayName
            wifiConnected: network.wifiConnected
            powerBackend: power
            presentationOutputs: (Quickshell.env("POND_LOCK_OUTPUTS") || "").split(",").filter(name => name.length > 0)
            introRequest: root.introRequest
            onFinished: locker.active = false
        }
    }
    Timer {
        id: suspendWait
        property int checks: 0
        interval: 100
        repeat: true
        onTriggered: {
            if (root.session && root.session.secure) {
                stop();
                power.suspend();
            } else if (++checks > 30) {
                stop();
                console.warn("Session lock was not confirmed; refusing to suspend");
            }
        }
    }
    IpcHandler {
        target: "lockscreen"
        function lock(): void { root.lock(); }
        // Lock under cells matching the shell's cover: its colors, and the
        // screen and point its wave started from (centers on other screens).
        function lockFrom(fill: string, edge: string, screen: string, x: real, y: real): void {
            root.lockFrom({ fill, edge, screen, x, y });
        }
        function lockAndSuspend(): void { root.lockAndSuspend(); }
        function isLocked(): bool { return locker.active; }
        function isSecure(): bool { return root.session !== null && root.session.secure; }
    }
}
