import QtQuick
import ".." as Shell

Item {
  id: root
  property int frame: 0
  implicitWidth: 16
  implicitHeight: 16

  Timer {
    interval: 500
    repeat: true
    running: root.visible
    onTriggered: root.frame = (root.frame + 1) % 5
  }

  Repeater {
    model: [[6, 0, "#cba6f7"], [12, 6, "#ff9f67"], [6, 12, "#94e2d5"], [0, 6, "#ffdc67"], [6, 6, "#b0ff4f"]]
    delegate: Rectangle {
      required property int index
      required property var modelData
      x: modelData[0]
      y: modelData[1]
      width: 4
      height: 4
      radius: 2
      color: index === root.frame ? modelData[2] : Qt.alpha(Shell.Theme.palette.overlay, 0.2)
    }
  }
}
