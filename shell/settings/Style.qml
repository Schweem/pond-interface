pragma Singleton
import QtQuick
import ".." as Shell

QtObject {
  readonly property color overlay: Shell.Theme.palette.settingsOverlay
  readonly property real overlayOpacity: 0.7
  readonly property color card: Shell.Theme.palette.settingsCard
  readonly property color hover: Shell.Theme.palette.settingsHover
  readonly property color sessionControl: Shell.Theme.palette.sessionControl
  readonly property int sessionSize: 127
  readonly property int radius: 12
  readonly property int staggerInterval: 28
  readonly property int revealDuration: 32
  readonly property int closeDuration: 180
  // Leaving eases in so the fade starts gently instead of dropping out at once.
  readonly property int exitDuration: 260
  readonly property int exitEasing: Easing.InOutCubic
  readonly property int hoverDuration: 100
}
