pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import ".." as Shell

Singleton {
  id: root
  readonly property UPowerDevice device: UPower.displayDevice
  readonly property bool present: device.ready && device.isPresent
      && device.type === UPowerDeviceType.Battery
  readonly property real percentage: present ? Math.max(0, Math.min(100, device.percentage * 100)) : 0
  readonly property bool charging: present && (device.state === UPowerDeviceState.Charging || !UPower.onBattery)
  readonly property string description: present
      ? "Battery " + Math.round(percentage) + "%, " + UPowerDeviceState.toString(device.state) : ""
  readonly property int level: Math.round(percentage)
  readonly property bool low: present && !charging && level <= 10
  readonly property int lowStage: level <= 3 ? 2 : level <= 5 ? 1 : 0
  readonly property color lowColor: Shell.Theme.palette.lowColors[lowStage]
  readonly property color lowSurface: Shell.Theme.palette.lowSurfaces[lowStage]
  // Warning text and icons drawn on lowSurface.
  readonly property color lowText: Shell.Theme.palette.lowInkText ? Shell.Theme.palette.foreground : lowColor
  readonly property int alertLevel: !low ? 0 : level <= 3 ? 3 : level <= 5 ? 5 : 10
  property int alert: 0
  property int alerted: 0
  readonly property var profiles: [
    { profile: PowerProfile.PowerSaver, name: "Eco", icon: "eco", accent: "#CBE25B" },
    { profile: PowerProfile.Balanced, name: "Balanced", icon: "balanced", accent: "#E99FFF" },
    { profile: PowerProfile.Performance, name: "Performance", icon: "performance", accent: "#FFE51D" }
  ]

  onChargingChanged: if (charging) { alerted = 0; alert = 0; }
  onAlertLevelChanged: {
    if (alertLevel === 0 || (alerted && alertLevel >= alerted)) return;
    alerted = alertLevel;
    alert = alertLevel;
    if (alertLevel === 3) alertTimer.stop();
    else alertTimer.restart();
  }

  Timer {
    id: alertTimer
    interval: 5000
    onTriggered: root.alert = 0
  }
}
