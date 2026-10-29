import QtQuick
import Quickshell
import Quickshell.Wayland

// One screen's cells for ThemeTransition. The window only exists while a
// transition runs and never takes input.
Scope {
  id: root
  required property var screen

  LazyLoader {
    active: ThemeTransition.running

    PanelWindow {
      id: window
      screen: root.screen
      color: "transparent"
      anchors { top: true; bottom: true; left: true; right: true }
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "pond-theme-transition"
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      mask: Region {}

      // Fixed for the whole transition so the grid never shifts mid-wave.
      readonly property var grid: ThemeTransition.layout(width, height,
          ThemeTransition.originOn(root.screen, width, height))
      readonly property int size: ThemeTransition.cellSize

      Repeater {
        model: window.width > 0 ? window.grid.cols * window.grid.rows : 0

        Rectangle {
          required property int index
          readonly property int i: index % window.grid.cols - window.grid.left
          readonly property int j: Math.floor(index / window.grid.cols) - window.grid.top
          readonly property int ring: ThemeTransition.ring(i, j)
          // One pixel wider so neighbours share a single edge line.
          x: window.grid.x - window.size / 2 + i * window.size
          y: window.grid.y - window.size / 2 + j * window.size
          width: window.size + 1
          height: width
          visible: ThemeTransition.phase === "cover" ? ring <= ThemeTransition.step
              : ring >= ThemeTransition.step
          color: ThemeTransition.incoming.transitionFill
          border.width: 1
          border.color: ThemeTransition.incoming.transitionEdge
          antialiasing: false
        }
      }
    }
  }
}
