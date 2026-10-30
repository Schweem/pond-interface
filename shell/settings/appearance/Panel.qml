pragma ComponentBehavior: Bound
import QtQuick
import "." as Appearance
import ".." as Settings
import "../display" as Display
import "../.." as Shell

Settings.Modal {
  id: root
  title: "Appearance"
  contentHeight: fields.y + fields.height + 30
  onBackRequested: Settings.State.back()
  Keys.onEscapePressed: Settings.State.back()

  Item {
    width: root.width; height: 241
    Text {
      x: 103; y: 83; height: 25
      text: "Theme:"; font.family: Shell.Theme.fontFamily; font.pixelSize: 15
      color: Shell.Theme.palette.foregroundMuted; verticalAlignment: Text.AlignVCenter
    }
    Text {
      x: 440; y: 83; height: 25
      text: Shell.Theme.palette.label
      font.family: Shell.Theme.fontFamily; font.pixelSize: 15
      color: Shell.Theme.palette.themeLabel; opacity: 0.7; verticalAlignment: Text.AlignVCenter
    }
    Text {
      x: 440; y: 107; height: 25
      text: upcoming.hovered ? "Coming soon"
          : nightMarsh.hovered && !nightMarsh.selected ? "Night Marsh"
          : marsh.hovered && !marsh.selected ? "Marsh" : ""
      font.family: Shell.Theme.fontFamily; font.pixelSize: 15
      color: Shell.Theme.palette.foregroundMuted; verticalAlignment: Text.AlignVCenter
      opacity: text ? 1 : 0
      Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
    }
    ThemeButton {
      id: nightMarsh; objectName: "themeNightMarsh"
      x: 194; y: 103; themeKey: "night-marsh"; label: "Night Marsh"
      idleRotation: 45; idleScale: 28 / 40
      selected: Shell.Theme.name === "night-marsh"
      onClicked: { Shell.ScreenTransition.startFrom(nightMarsh); Appearance.State.selectTheme("night-marsh"); }
    }
    ThemeButton {
      id: marsh; objectName: "themeMarsh"
      x: 294; y: 103; themeKey: "marsh"; label: "Marsh"
      idleRotation: 45; idleScale: 28 / 40
      selected: Shell.Theme.name === "marsh"
      onClicked: { Shell.ScreenTransition.startFrom(marsh); Appearance.State.selectTheme("marsh"); }
    }
    ThemeButton {
      id: upcoming; objectName: "themeComingSoon"
      x: 243; y: 12; available: false; label: "Coming soon"
    }
  }
  Column {
    id: fields
    x: 30; y: 241; width: root.width - 60; spacing: 8
    Accordion {
      objectName: "wallpaperSection"
      width: parent.width; title: "Wallpaper"
      summary: Appearance.State.wallpaperMode === "dynamic" ? "Theme" : "Custom"
      expanded: Appearance.State.expandedSection === "wallpaper"
      expandedHeight: 202
      onToggled: Appearance.State.toggleSection("wallpaper")
      WallpaperOption {
        objectName: "dynamicWallpaper"
        y: 5; width: parent.width; dynamic: true
        selected: Appearance.State.wallpaperMode === "dynamic"
        onClicked: Appearance.State.selectDynamic()
      }
      WallpaperOption {
        objectName: "customWallpaper"
        y: 68; width: parent.width
        selected: Appearance.State.wallpaperMode === "custom"
        onClicked: Appearance.State.pickWallpaper()
      }
    }
    Accordion {
      objectName: "brightnessSection"
      width: parent.width; title: "Screen brightness"
      summary: Appearance.State.brightnessAvailable ? Math.round(Appearance.State.brightness * 100) + "%" : "Unavailable"
      expanded: Appearance.State.expandedSection === "brightness"
      expandedHeight: 109
      onToggled: Appearance.State.toggleSection("brightness")
      Shell.Slider {
        id: brightnessSlider
        objectName: "brightnessSlider"
        x: 0; y: 5; width: parent.width
        externalValue: Appearance.State.brightness
        showInlineValue: false
        interactive: Appearance.State.brightnessAvailable
        opacity: interactive ? 1 : 0.3
        onMoved: Appearance.State.setBrightness(brightnessSlider.value)
        onDragStarted: Appearance.State.draggingBrightness = true
        onDragFinished: { Appearance.State.draggingBrightness = false; Appearance.State.flushBrightness(); }
        activeFocusOnTab: interactive
        Accessible.role: Accessible.Slider
        Accessible.name: "Screen brightness"
        Keys.onLeftPressed: Appearance.State.setBrightness(value - 0.05)
        Keys.onRightPressed: Appearance.State.setBrightness(value + 0.05)
      }
      Text {
        visible: !Appearance.State.brightnessAvailable
        y: 36; width: parent.width
        text: "This display does not expose brightness control."
        color: Shell.Theme.palette.foregroundMuted; font.family: Shell.Theme.fontFamily; font.pixelSize: 11
      }
    }
    Accordion {
      objectName: "displaySection"
      width: parent.width; title: "Display"
      summary: Display.State.summary
      navigation: true
      onToggled: Settings.State.openPage("display")
    }
    Text {
      width: parent.width
      visible: Appearance.State.error !== ""
      text: Appearance.State.error
      wrapMode: Text.Wrap
      font.family: Shell.Theme.fontFamily; font.pixelSize: 13; color: Shell.Theme.palette.errorText
    }
  }
}
