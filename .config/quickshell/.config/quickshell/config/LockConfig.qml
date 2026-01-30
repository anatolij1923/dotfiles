import Quickshell.Io

JsonObject {

    property real dimOpacity: 0.3

    property Blur blur: Blur {}
    component Blur: JsonObject {
        property bool enabled: true
        property int radius: 5
    }
}
