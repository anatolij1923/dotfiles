import Quickshell.Io

JsonObject {
    property Transparency transparency: Transparency {}

    // TODO: make transparency support
    component Transparency: JsonObject {
        property bool enabled: false
        property real alpha: 0.8
    }
}
