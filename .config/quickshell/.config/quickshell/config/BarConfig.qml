import Quickshell.Io

JsonObject {
    property Workspaces workspaces: Workspaces {}
    property Margins margins: Margins {}
    property int height: 50
    property bool bottom: false
    property bool floating: false
    property bool monochromeTrayIcons: false

    property bool transparentCenterWidgets: false

    property Tray tray: Tray {}
    property Battery battery: Battery {}

    component Battery: JsonObject {
        property int margins: 1
    }

    component Margins: JsonObject {
        property int vertical: 5
        property int horizontal: 5
    }

    component Workspaces: JsonObject {
        property int shown: 5
    }

    component Tray: JsonObject {
        property bool monochromeTrayIcons: false
        property real desaturation: 0.6
    }
}
