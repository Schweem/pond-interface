import QtQuick

// A framed value under an ink caption bar, for the date and time.
Item {
    id: root
    required property var theme
    property string label: ""
    property string value: ""
    height: 96

    Rectangle {
        anchors.fill: parent
        color: root.theme.paper
        border.color: root.theme.ink
        border.width: 1
    }
    Rectangle {
        width: parent.width
        height: 22
        color: root.theme.ink
        Text {
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            color: root.theme.paper
            font.family: root.theme.monoFont
            font.weight: Font.DemiBold
            font.pixelSize: 11
            font.letterSpacing: 2
        }
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "//"
            color: root.theme.accent
            font.family: root.theme.monoFont
            font.weight: Font.DemiBold
            font.pixelSize: 11
        }
    }
    Text {
        renderType: Text.CurveRendering
        objectName: root.objectName + "Value"
        x: 12
        y: 22
        width: parent.width - 24
        height: parent.height - 22
        text: root.value
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.HorizontalFit
        minimumPixelSize: 20
        color: root.theme.ink
        font.family: root.theme.displayFont
        font.styleName: "Medium"
        font.pixelSize: 40
        font.letterSpacing: -1
    }
}
