import Quickshell.Io

JsonObject {
    property Blur blur: Blur {}
    component Blur: JsonObject {
        property bool enabled: true 
        property int radius: 15
    }
}
