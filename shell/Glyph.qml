pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

// A monochrome asset drawn in a theme color. Most SVGs are white; darker ones
// (black check marks, grey placeholders) are lifted to white before taking
// the tint. The colorize pass only runs when the tint differs from the source.
Image {
  id: root
  property color tint: Theme.palette.iconTint
  property color sourceColor: "white"
  smooth: true
  layer.enabled: !Qt.colorEqual(tint, sourceColor)
  layer.effect: MultiEffect {
    brightness: 1 - root.sourceColor.hslLightness
    colorization: 1
    colorizationColor: root.tint
  }
}
