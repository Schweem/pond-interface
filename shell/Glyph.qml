pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

// A monochrome asset drawn in a theme color. The SVGs are drawn in white, so
// the colorize pass only runs when the tint is something else.
Image {
  id: root
  property color tint: Theme.palette.iconTint
  smooth: true
  layer.enabled: !Qt.colorEqual(tint, "white")
  layer.effect: MultiEffect { colorization: 1; colorizationColor: root.tint }
}
