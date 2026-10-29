pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

// A monochrome asset drawn in a theme color. Most SVGs are white; a few
// (check marks) are black, which needs lifting before it can take a tint.
// The colorize pass only runs when the tint differs from the source color.
Image {
  id: root
  property color tint: Theme.palette.iconTint
  property color sourceColor: "white"
  smooth: true
  layer.enabled: !Qt.colorEqual(tint, sourceColor)
  layer.effect: MultiEffect {
    brightness: Qt.colorEqual(root.sourceColor, "black") ? 1 : 0
    colorization: 1
    colorizationColor: root.tint
  }
}
