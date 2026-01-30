import Quickshell.Io

JsonObject {
    property Transparency transparency: Transparency {}
    property Theming theming: Theming {}

    property bool darkMode: true
    property bool enableScreenCorners: true

    component Transparency: JsonObject {
        property bool enabled: true // idk why ts dont wanna work when set up in false by default
        property real alpha: 0.8
    }

    component Theming: JsonObject {
        property Templates templates: Templates {}

        property string matugenMode: "scheme-tonal-spot"
    }

    component Templates: JsonObject {
        property bool hyprland: true
        property bool niri: false
        property bool wezterm: true
        property bool gtk: false
        property bool zellij: false
        property bool yazi: false
    }
}
