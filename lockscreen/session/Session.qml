pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Wayland
import "." as Session
import "../frontend" as Frontend

Item {
    id: root

    required property var powerBackend
    property string displayName: ""
    property string paletteName: "marsh"
    property bool wifiConnected: false
    property list<string> presentationOutputs: []
    // Cells handed over by the shell's cover; see Intro.
    property var introRequest: null
    readonly property bool secure: lockSession.secure
    readonly property bool configuredOutputPresent: Quickshell.screens.some(screen => presentationOutputs.includes(screen.name))

    signal finished

    function showsPresentation(screen) {
        return !configuredOutputPresent || presentationOutputs.includes(screen.name);
    }

    Intro {
        id: intro
        request: root.introRequest
    }
    Authentication { id: auth }
    Frontend.Theme {
        id: lockTheme
        name: root.paletteName
    }
    Session.Transition {
        id: handoff
        controller: ui.controller
        exitTransition: ui.exitTransition
        released: flow.phase === "exiting"
        displayName: root.displayName
        wifiConnected: root.wifiConnected
        theme: lockTheme
        presentationOutputs: Quickshell.screens.filter(screen => root.showsPresentation(screen)).map(screen => screen.name)
    }
    Frontend.Controller {
        id: ui
        powerBackend: root.powerBackend
        inputBlocked: !auth.pamReady
    }
    SessionController {
        id: flow
        frontend: ui
        authentication: auth
        transition: handoff
        onReleaseRequested: lockSession.locked = false
        onFinished: root.finished()
    }

    WlSessionLock {
        id: lockSession
        locked: true

        WlSessionLockSurface {
            id: surface
            readonly property bool showPresentation: root.showsPresentation(screen)
            color: showPresentation ? lockTheme.paper : "black"

            // Under an intro the lock screen loads without blocking, so the
            // cells (and the secure lock) are up straight away.
            Loader {
                id: content
                anchors.fill: parent
                asynchronous: intro.phase === "held"
                sourceComponent: Frontend.Screen {
                    controller: ui
                    theme: lockTheme
                    showPresentation: surface.showPresentation
                    displayName: root.displayName
                    wifiConnected: root.wifiConnected
                }
            }
            // Clear a screen's cells once its lock screen has drawn beneath them.
            Item {
                id: drawn
                Connections {
                    target: drawn.Window.window
                    enabled: content.status === Loader.Ready && intro.phase === "held"
                    function onFrameSwapped() {
                        intro.setReady(surface.screen.name);
                    }
                }
            }
            IntroCover {
                anchors.fill: parent
                intro: intro
                screen: surface.screen
            }
        }
    }
}
