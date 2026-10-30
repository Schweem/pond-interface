pragma ComponentBehavior: Bound
import QtQuick
import "Glyphs.js" as Glyphs

// The ink bar across the top: status and compositor on the left, the user
// on a tab hanging from the centre, with arrows when there are several.
Item {
    id: root
    required property var theme
    property string status: "LOCKED"
    property string displayName: ""
    property bool multipleUsers: false
    property bool wifiConnected: false
    property var compositors: []
    property int compositorIndex: -1
    signal userStepRequested(int direction)
    signal compositorRequested(int index)
    height: 40

    component Label: Text {
        color: root.theme.paper
        font.family: root.theme.monoFont
        font.weight: Font.Medium
        font.pixelSize: 12
        font.letterSpacing: 2
    }

    Rectangle {
        anchors.fill: parent
        color: root.theme.ink
    }

    Row {
        x: 16
        height: 40
        spacing: 12

        Glyph {
            objectName: "wifiStatus"
            anchors.verticalCenter: parent.verticalCenter
            width: 18
            height: 18
            visible: root.wifiConnected
            glyph: Glyphs.wifi
            color: root.theme.paper
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: "MARSH ▪ " + root.status
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.compositors.length > 1
            text: "▪"
        }
        Item {
            id: selector
            width: Math.max(selectedName.implicitWidth + 24, alternatives.implicitWidth)
            height: 40
            visible: root.compositors.length > 1
            readonly property bool expanded: root.enabled && hover.hovered
            HoverHandler { id: hover }
            Label {
                id: selectedName
                anchors.verticalCenter: parent.verticalCenter
                text: (root.compositors[root.compositorIndex] || "").toUpperCase()
            }
            Glyph {
                x: selectedName.implicitWidth + 2
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20
                glyph: Glyphs.chevronThin
                color: root.theme.paper
            }
            Rectangle {
                y: 40
                x: -10
                width: alternatives.width + 20
                height: alternatives.height
                visible: selector.expanded && alternatives.height > 0
                color: root.theme.paper
                border.color: root.theme.ink
                border.width: 1
                Column {
                    id: alternatives
                    x: 10
                    Repeater {
                        model: root.compositors
                        delegate: Item {
                            id: row
                            required property string modelData
                            required property int index
                            objectName: "compositor" + index
                            visible: index !== root.compositorIndex
                            width: Math.max(110, label.implicitWidth)
                            height: visible ? 32 : 0
                            Label {
                                id: label
                                anchors.verticalCenter: parent.verticalCenter
                                text: row.modelData.toUpperCase()
                                color: root.theme.ink
                                opacity: choice.containsMouse ? 1 : 0.6
                            }
                            MouseArea {
                                id: choice
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.compositorRequested(row.index)
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: nameplate
        objectName: "userNameplate"
        x: (root.width - width) / 2
        width: Math.min(displayNameText.implicitWidth + 40, root.width * 0.4)
        height: 48
        color: root.theme.accent
        Text {
            renderType: Text.CurveRendering
            id: displayNameText
            objectName: "displayNameLabel"
            anchors.centerIn: parent
            width: parent.width - 40
            text: root.displayName
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            color: root.theme.onAccent
            font.family: root.theme.displayFont
            font.styleName: "Medium"
            font.pixelSize: 20
        }
    }

    component UserArrow: Rectangle {
        id: arrow
        required property int direction
        readonly property bool hovered: mouse.containsMouse && enabled
        width: 40; height: 40
        visible: root.multipleUsers
        color: hovered ? Qt.alpha(root.theme.paper, 0.15) : "transparent"
        Glyph {
            anchors.centerIn: parent
            width: 24; height: 24
            glyph: Glyphs.chevron
            color: root.theme.paper
            rotation: arrow.direction > 0 ? -90 : 90
            opacity: arrow.hovered ? 1 : 0.7
        }
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.userStepRequested(arrow.direction)
        }
    }
    UserArrow {
        objectName: "previousUser"
        x: nameplate.x - width
        direction: -1
    }
    UserArrow {
        objectName: "nextUser"
        x: nameplate.x + nameplate.width
        direction: 1
    }
}
