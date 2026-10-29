import QtQuick
import Quickshell

// Hides a theme switch behind ScreenTransition: the screens cover in the
// incoming theme's cells, the theme swaps underneath, then they clear.
// Created once by the shell root so it holds switches from startup.
Scope {
  id: root

  function start() {
    if (Theme.requested === Theme.name) return;
    ScreenTransition.run({
      palette: Theme.palettes[Theme.requested],
      covered: () => Theme.apply()
    });
  }

  Component.onCompleted: Theme.holdSwitch = true

  Connections {
    target: Theme
    function onRequestedChanged() { root.start(); }
  }

  // A switch asked for mid-transition runs once the screens clear.
  Connections {
    target: ScreenTransition
    function onFinished() { root.start(); }
  }
}
