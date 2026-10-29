import QtQuick
import QtQuick.Window

// Put inside a window to hear once it has put its first frame on screen.
Item {
  id: root
  signal drawn
  property bool done: false

  Connections {
    target: root.Window.window
    enabled: !root.done
    function onFrameSwapped() {
      root.done = true;
      root.drawn();
    }
  }
}
