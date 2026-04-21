import Quickshell.Io

JsonObject {
    property int gapsIn: 0
    property int gapsOut: 0
    property int borderSize: 0
    property int rounding: 0

    property Blur blur: Blur {}

    property bool sendNotification: true

    component Blur: JsonObject {
        property bool disableBlur: true
        property int blurSize: 0
        property int blurPasses: 0
    }
}
