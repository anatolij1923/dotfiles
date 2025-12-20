// qml/Configuration/Bar.qml
import Quickshell.Io

JsonObject {
    property Workspaces workspaces: Workspaces {}
    property int height: 50
    property bool bottom: false

    component Workspaces: JsonObject {
        property int shown: 5
    }
}
