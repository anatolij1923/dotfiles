import Quickshell.Io

JsonObject {
    property bool enable: false
    property real height: 60
    property real hoverRegionHeight: 2
    property bool pinnedOnStartup: false
    property bool hoverToReveal: true // When false, only reveals on empty workspace
    property list<string> pinnedApps: [ // IDs of pinned entries
        "nautilus", "wezterm",]
    property list<string> ignoredAppRegexes: []
}
