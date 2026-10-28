import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import ".." as Shell

// One live window marker. The same primitive scales between the 40px
// expanded rail and the 32px collapsed stack while retaining app activation
// across both layouts.
Item {
  id: root

  property var windowData: ({})
  property real controlSize: Shell.Theme.workspaceControlSize
  property bool interactive: true
  property bool lifted: false
  signal activated(var windowId)

  readonly property bool hovered: pointer.containsMouse

  implicitWidth: controlSize
  implicitHeight: controlSize

  Shell.Shadow {
    anchors.fill: chrome
    cornerRadius: chrome.radius
    shadows: root.visible && root.lifted && Shell.Theme.palette.dragPreview ? Shell.PanelStyle.controlShadows : []
  }

  Rectangle {
    id: chrome
    anchors.fill: parent
    radius: width / 2
    antialiasing: true
    // Fade alpha without interpolating the fill through transparent black.
    color: root.lifted ? Shell.Theme.palette.workspaceDragBackground : root.hovered ? Shell.Theme.palette.workspaceControlHover
        : Qt.rgba(Shell.Theme.palette.workspaceControlHover.r, Shell.Theme.palette.workspaceControlHover.g,
                  Shell.Theme.palette.workspaceControlHover.b, 0)
    border.color: root.lifted ? "#CBA6F7" : Shell.Theme.palette.workspaceIconOutline
    border.width: root.hovered ? 0 : Shell.Theme.sidebarStrokeWidth
    layer.enabled: root.lifted && !Shell.Theme.palette.dragPreview
    layer.effect: MultiEffect {
      shadowEnabled: true
      shadowBlur: 0.5
      blurMax: 10
      shadowOpacity: 0.4
      shadowHorizontalOffset: 2
      shadowVerticalOffset: 5
    }

    Behavior on color {
      ColorAnimation {
        duration: Shell.Theme.sidebarHoverDuration
        easing.type: Easing.OutCubic
      }
    }
  }

  IconImage {
    anchors.centerIn: parent
    visible: (root.windowData.iconSource || "") !== ""
    width: Shell.Theme.workspaceIconSize * (root.lifted ? Shell.Theme.palette.workspaceDragGlyphScale : 1)
    height: width
    source: root.windowData.iconSource || ""
    asynchronous: true
    smooth: true
    opacity: root.hovered || root.lifted ? 1.0 : Shell.Theme.palette.idleIconOpacity

    Behavior on opacity { Shell.HoverAnimation {} }
  }

  TerminalIndicator {
    anchors.centerIn: parent
    visible: (root.windowData.dotState || "") !== ""
    dotState: root.windowData.dotState || "read"
    loaderVariant: root.windowData.loaderVariant || 1
    scale: root.controlSize / Shell.Theme.workspaceControlSize
        * (root.lifted ? Shell.Theme.palette.workspaceDragGlyphScale : 1)
  }

  MouseArea {
    id: pointer
    anchors.fill: parent
    enabled: root.interactive
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (root.windowData.winId !== undefined)
        root.activated(root.windowData.winId);
    }
  }
}
