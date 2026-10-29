import QtQuick
import Quickshell
import Quickshell.Wayland

// One screen's cells for ScreenTransition. The window only exists while a
// transition runs, and only takes pointer input while a cover is held.
Scope {
  id: root
  required property var screen

  LazyLoader {
    active: ScreenTransition.running

    PanelWindow {
      id: window
      readonly property bool held: ScreenTransition.phase === "held"
      screen: root.screen
      color: "transparent"
      anchors { top: true; bottom: true; left: true; right: true }
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "pond-screen-transition"
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      // A held cover hides a desktop that is going away; don't click through it.
      mask: Region {
        width: window.held ? window.width : 0
        height: window.held ? window.height : 0
      }

      // Fixed for the whole transition so the grid never shifts mid-wave.
      readonly property var grid: ScreenTransition.layout(width, height,
          ScreenTransition.originOn(root.screen, width, height))
      readonly property int size: ScreenTransition.cellSize

      Repeater {
        model: window.width > 0 ? window.grid.cols * window.grid.rows : 0

        Rectangle {
          required property int index
          readonly property int i: index % window.grid.cols - window.grid.left
          readonly property int j: Math.floor(index / window.grid.cols) - window.grid.top
          readonly property int ring: ScreenTransition.ring(i, j)
          // One pixel wider so neighbours share a single edge line.
          x: window.grid.x - window.size / 2 + i * window.size
          y: window.grid.y - window.size / 2 + j * window.size
          width: window.size + 1
          height: width
          visible: ScreenTransition.phase === "cover" ? ring <= ScreenTransition.step
              : window.held || ring >= ScreenTransition.step
          // Still the base color until the band reaches it.
          readonly property bool plain: ScreenTransition.hasBase
              && (window.held || ring >= ScreenTransition.step + ScreenTransition.band)
          color: plain ? ScreenTransition.base : ScreenTransition.palette.transitionFill
          border.width: 1
          border.color: plain ? ScreenTransition.base : ScreenTransition.palette.transitionEdge
          antialiasing: false
        }
      }
    }
  }
}
