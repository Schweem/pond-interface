pragma Singleton
import QtQuick
import ".." as Shell

QtObject {
  readonly property int panelWidth: 280
  readonly property int interactiveWidth: 288
  readonly property int rowHeight: 92
  readonly property int panelHeaderHeight: 60
  readonly property int panelMaxHeight: 647
  readonly property int desktopMargin: 10
  readonly property int radius: 16
  readonly property int contentPadding: 16
  readonly property int summaryIconSize: 14
  readonly property int closeSize: 24
  readonly property int closeIconSize: 16
  readonly property color hover: Shell.Theme.palette.panelHover
  readonly property color closeHover: Shell.Theme.palette.panelBorder
  readonly property color foreground: Shell.Theme.palette.foreground
  readonly property color divider: Shell.Theme.palette.panelDivider
  readonly property real secondaryIconOpacity: 0.4
  readonly property int panelDuration: 180
}
