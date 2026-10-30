pragma Singleton
import QtQuick
import QtCore
import Quickshell
import Quickshell.Io
import "palettes" as Palettes

Singleton {
  id: root
  property string name: "marsh"
  // The theme chosen in theme.json. It applies straight away unless something
  // holds the switch (a transition), which calls apply() when it is ready.
  property string requested: "marsh"
  property bool holdSwitch: false
  property bool loaded: false
  function apply() {
    name = requested;
    // The launcher follows, live; it keeps its theme if vicinae isn't there.
    Quickshell.execDetached(["vicinae", "theme", "set", palette.launcherTheme]);
  }
  readonly property var palettes: ({ marsh: marshPalette, "night-marsh": nightMarshPalette })
  readonly property Palettes.ThemePalette palette: palettes[name]

  Palettes.Marsh { id: marshPalette }
  Palettes.NightMarsh { id: nightMarshPalette }

  function reload() { themeFile.reload(); }

  FileView {
    id: themeFile
    path: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/pond-interface/theme.json"
    watchChanges: true
    printErrors: false
    // Read the first load in place so the shell's first frame is in its theme:
    // loaded only arrives once the windows exist, so reading text() at
    // creation is what applies it in time.
    blockLoading: true
    blockAllReads: true
    onFileChanged: reload()
    onLoaded: {
      try {
        // Unthemed was the dark theme before Night Marsh.
        const saved = JSON.parse(text()).theme;
        const theme = saved === "unthemed" ? "night-marsh" : saved;
        root.requested = root.palettes.hasOwnProperty(theme) ? theme : "marsh";
        // The first read applies directly so the shell starts in its theme.
        if (!root.holdSwitch || !root.loaded) root.apply();
        root.loaded = true;
      }
      catch (error) { console.warn("Could not read theme selection:", error); }
    }
    Component.onCompleted: text()
  }

  readonly property int sidebarOuterMargin: 10
  readonly property int sidebarCardExpandedWidth: 156
  readonly property int sidebarCardCollapsedWidth: 48
  readonly property int sidebarCardRadius: 16
  readonly property int sidebarCardGap: 6
  readonly property int sidebarFadeWidth: 12
  readonly property int sidebarRowHorizontalPadding: 16
  readonly property int sidebarSimpleRowHeight: 48
  readonly property int sidebarTimeExpandedHeight: 58
  readonly property int workspaceControlSize: 40
  readonly property int workspaceCollapsedControlSize: 32
  readonly property int workspaceControlGap: 8
  readonly property int workspaceControlPitch: workspaceControlSize + workspaceControlGap
  readonly property int workspaceCollapsedControlPitch:
      workspaceCollapsedControlSize + workspaceCollapsedControlGap
  readonly property int workspaceCollapsedControlGap: 8
  readonly property int workspaceContentPadding: (sidebarCardExpandedWidth
      - workspaceGridColumns * workspaceControlSize
      - (workspaceGridColumns - 1) * workspaceControlGap) / 2
  readonly property int workspaceActiveIndicatorInset: 4
  readonly property int workspaceIconSize: 16
  readonly property int workspaceGridColumns: 3
  readonly property int workspaceGridMinimumRows: 3
  readonly property int workspaceGridMinimumHeight: workspaceContentPadding * 2
      + workspaceGridMinimumRows * workspaceControlSize
      + (workspaceGridMinimumRows - 1) * workspaceControlGap
  readonly property int workspacePlaceholderDotSize: 4
  readonly property int workspaceCollapsedHeaderHeight: 37
  readonly property int sidebarHoverDuration: 120
  readonly property int sidebarWorkspaceSwitchDuration: 180
  readonly property int workspaceDragSnapDuration: 110
  readonly property int mediaControlSize: 20
  readonly property int mediaRevealDuration: 180
  readonly property int sidebarStrokeWidth: 1
  readonly property string fontFamily: "Onest"
  readonly property string titleFontFamily: "Pond Gramercy"
  readonly property string plexFontFamily: "IBM Plex Mono"

  function collapseWidth(progress) { return ramp(progress, 0, 0.56); }
  function collapseHeight(progress) { return ramp(progress, 0.56, 1); }

  function clamp01(value) { return Math.max(0, Math.min(1, value)); }
  function lerp(from, to, progress) {
    return from + (to - from) * clamp01(progress);
  }
  function ramp(progress, start, end) {
    return clamp01((progress - start) / (end - start));
  }
}
