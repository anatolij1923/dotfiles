import Quickshell.Io

JsonObject {
    property Workspaces workspaces: Workspaces {}
    property Margins margins: Margins {}
    property int height: 50
    property bool bottom: false
    property bool floating: false

    component Margins: JsonObject {
        property int top: 5
        property int bottom: 5
        property int left: 5
        property int right: 5
    }

    component Workspaces: JsonObject {
        property int shown: 5
        property bool highlightOccupied: true
    }
}
