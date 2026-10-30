pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import "form"
import "Glyphs.js" as Glyphs

Item {
    id: root

    required property var controller
    required property var exitTransition
    property var inputTarget: null
    property string revealText: ""
    property bool showPassword: false
    property bool passwordTooltipVisible: false
    readonly property bool revealContentVisible: lockDisplay.revealContentVisible
    property alias displayPhase: lockDisplay.displayPhase
    property bool interactive: true
    property bool powerInteractive: interactive
    property bool restartInteractive: false
    property bool wifiConnected: false
    property string displayName: ""
    property bool multipleUsers: false
    property var compositors: []
    property int compositorIndex: -1
    property date now: new Date()
    // What the header and footer call this screen: locked, or signing in.
    property string status: "LOCKED"
    property Theme theme: Theme {}
    property Component backgroundComponent: Component {
        Scenery {
            theme: root.theme
            gridCenterY: root.gridCenterY
        }
    }
    readonly property Item background: backgroundLoader.item as Item

    signal submitRequested
    signal shutdownRequested
    signal restartRequested
    signal userStepRequested(int direction)
    signal compositorRequested(int index)

    clip: true

    readonly property real canvasHeight: 1080
    // Form places the grid at y 320; 200 down is its centre.
    readonly property real gridCenterY: 520
    // Uniform scaling keeps the lock centered while wide layouts retain true
    // physical screen edges for the reveal/power controls and footer copy.
    readonly property real layoutScale: Math.min(height / canvasHeight, width / 960)
    // A window can have a fractional scale even when Screen reports a rounded one.
    readonly property real pixelScale: layoutScale * (Window.window?.devicePixelRatio ?? 1)

    onInteractiveChanged: {
        if (!interactive)
            showPassword = false;
    }

    function refocusInput() {
        if (inputTarget)
            inputTarget.forceActiveFocus();
    }

    Item {
        id: canvas
        objectName: "lockCanvas"
        // A surface starts at 0x0; keep the canvas finite until it has a size.
        width: root.layoutScale > 0 ? root.width / root.layoutScale : 0
        height: root.canvasHeight
        x: 0
        y: (root.height - height * root.layoutScale) / 2
        transform: Scale {
            origin.x: 0
            origin.y: 0
            xScale: root.layoutScale
            yScale: root.layoutScale
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.interactive
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onEntered: root.refocusInput()
            onClicked: root.refocusInput()
        }

        Item {
            id: backdrop
            anchors.fill: parent
            Loader {
                id: backgroundLoader
                objectName: "background"
                anchors.fill: parent
                active: root.backgroundComponent !== null
                sourceComponent: root.backgroundComponent
            }
        }
        ShaderEffectSource {
            id: backdropTexture
            anchors.fill: parent
            textureSize: Qt.size(Math.ceil(canvas.width * root.pixelScale), Math.ceil(canvas.height * root.pixelScale))
            sourceItem: backdrop
            hideSource: true
            // Once the reveal starts, DesktopCover draws the backdrop per quadrant.
            opacity: root.exitTransition.revealedQuadrantCount === 0 ? 1 : 0
        }

        Item {
            id: periphery
            objectName: "periphery"
            anchors.fill: parent
            opacity: root.exitTransition.peripheryVisible ? 1 : 0
            visible: opacity > 0

            Behavior on opacity { NumberAnimation { duration: 60 } }

            UserHeader {
                objectName: "identityHeader"
                width: parent.width
                theme: root.theme
                status: root.status
                displayName: root.displayName
                multipleUsers: root.multipleUsers
                compositors: root.compositors
                compositorIndex: root.compositorIndex
                wifiConnected: root.wifiConnected
                enabled: root.interactive
                onUserStepRequested: direction => root.userStepRequested(direction)
                onCompositorRequested: index => root.compositorRequested(index)
            }

            Text {
                id: passwordTooltip
                objectName: "passwordTooltip"
                visible: root.passwordTooltipVisible && root.interactive && lockDisplay.dateTimeVisible
                    && root.controller.visibleCellCount === 13
                x: (canvas.width - width) / 2
                y: 284
                text: "ENTER PASSWORD"
                color: root.theme.ink
                font.family: root.theme.monoFont
                font.weight: Font.DemiBold
                font.pixelSize: 11
                font.letterSpacing: 2
            }

            // Readouts sit midway between the edge controls and the widest grid.
            Item {
                id: readouts
                readonly property real gridLeft: (canvas.width - 400) / 2 - 160
                readonly property real centre: (80 + gridLeft) / 2
                readonly property real boxWidth: Math.max(180, Math.min(260, gridLeft - 80 - 48))
                anchors.fill: parent
                opacity: lockDisplay.dateTimeVisible ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 150 } }

                Readout {
                    objectName: "lockDate"
                    x: readouts.centre - width / 2
                    y: root.gridCenterY - height / 2
                    width: readouts.boxWidth
                    theme: root.theme
                    label: "DATE"
                    value: Qt.formatDate(root.now, "ddd, MMM d")
                }
                Readout {
                    objectName: "lockTime"
                    x: canvas.width - readouts.centre - width / 2
                    y: root.gridCenterY - height / 2
                    width: readouts.boxWidth
                    theme: root.theme
                    label: "LOCAL"
                    value: Qt.formatTime(root.now, "h:mm AP")
                }
            }

            Rectangle {
                objectName: "revealButton"
                x: 0
                y: root.gridCenterY - 40
                width: 80
                height: 80
                color: root.showPassword ? root.theme.ink
                    : revealMouse.containsMouse ? root.theme.accent : root.theme.paper
                border.color: root.theme.ink
                border.width: 2

                Glyph {
                    anchors.fill: parent
                    glyph: root.showPassword ? Glyphs.eyeOpen : Glyphs.eyeClosed
                    color: root.showPassword ? root.theme.paper : root.theme.ink
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: root.interactive
                    id: revealMouse
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.refocusInput();
                        root.showPassword = !root.showPassword;
                    }
                }
            }

            PowerMenu {
                objectName: "powerMenu"
                x: canvas.width - 80
                y: root.gridCenterY - 40
                theme: root.theme
                enabled: root.powerInteractive
                restartEnabled: root.restartInteractive
                onShutdownRequested: {
                    if (root.interactive)
                        root.refocusInput();
                    root.shutdownRequested();
                }
                onRestartRequested: {
                    if (root.interactive)
                        root.refocusInput();
                    root.restartRequested();
                }
            }

            Footer {
                anchors.fill: parent
                theme: root.theme
            }
        }

        Form {
            id: lockDisplay
            objectName: "lockDisplay"
            displayScale: root.layoutScale
            anchors.fill: parent
            controller: root.controller
            exitStep: root.exitTransition.exitStep
            theme: root.theme
            revealText: root.revealText
            showPassword: root.showPassword
            interactive: root.interactive
            onSubmitRequested: root.submitRequested()
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.now = new Date()
    }
}
