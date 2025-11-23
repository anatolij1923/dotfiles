import Quickshell.Io

JsonObject {
    property Transparency transparency: Transparency {}

    // TODO: make transparency support
    component Transparency: JsonObject {
        property bool enabled: true // idk why ts dont wanna work when set up in false by default
        property real alpha: 0.8
    }
}
