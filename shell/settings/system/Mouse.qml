pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Templates as T
import "." as System
import ".." as Settings
import "../.." as Shell

Settings.Modal {
  id: root
  objectName: "mousePanel"
  title: "Mouse sensitivity"; closeLabel: "Back to System"; bodyTop: 92
  contentHeight: fields.height + 30
  onBackRequested: Settings.State.back()
  Keys.onEscapePressed: Settings.State.back()
  Column {
    id: fields
    x: 30; width: root.width - 60; spacing: 6
    Repeater {
      model: [{key: "speed", title: "Mouse sensitivity", to: 1}, {key: "scroll", title: "Scrolling sensitivity", to: 2}]
      delegate: Rectangle {
        id: field
        required property var modelData
        width: fields.width; height: 107; radius: 12
        color: slider.visualFocus ? Shell.Theme.palette.controlHover : Shell.Theme.palette.controlFill
        Text {
          x: 20; y: (51 - height) / 2
          text: field.modelData.title; color: Shell.Theme.palette.foregroundMuted
          font.family: Shell.Theme.fontFamily; font.pixelSize: 15
        }
        Text {
          anchors.right: parent.right; anchors.rightMargin: 20; y: (51 - height) / 2
          text: Math.round(slider.value * 100) + "%"; color: Shell.Theme.palette.foregroundMuted
          font.family: Shell.Theme.fontFamily; font.pixelSize: 15
        }
        Repeater {
          model: 11
          delegate: Rectangle {
            required property int index
            x: 20 + index * 47.6; y: 83; width: 4; height: 4; radius: 2
            color: Shell.Theme.palette.sliderMark; opacity: 0.2
          }
        }
        T.Slider {
          id: slider
          objectName: "mouse" + field.modelData.key
          x: 20; y: 55; width: 480; height: 24
          leftPadding: 2; rightPadding: 2
          to: field.modelData.to; value: System.State.mouse[field.modelData.key]
          Accessible.name: field.modelData.title
          onMoved: System.State.setMouse(field.modelData.key, value)
          background: Rectangle {
            y: 4; width: slider.width; height: 16; radius: 8
            color: Shell.Theme.palette.panelTrack
            Rectangle {
              x: 1; y: 1; width: slider.leftPadding + slider.visualPosition * slider.availableWidth - 1
              height: 14; radius: 7
              color: Shell.Theme.palette.sliderMark
            }
          }
          handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * slider.availableWidth - width / 2
            width: 24; height: 24; radius: 12
            color: Shell.Theme.palette.sliderHandle; border.width: 2; border.color: field.color
          }
          HoverHandler { cursorShape: Qt.PointingHandCursor }
        }
      }
    }
    Settings.Field {
      objectName: "mouseAcceleration"
      width: parent.width; toggle: true
      title: "Pointer acceleration"; checked: System.State.mouse.acceleration
      onToggled: checked => System.State.setMouse("acceleration", checked)
    }
    Text {
      width: parent.width; visible: !!System.State.error
      text: System.State.error; color: Shell.Theme.palette.errorText; wrapMode: Text.Wrap
      font.family: Shell.Theme.fontFamily; font.pixelSize: 13
    }
  }
}
