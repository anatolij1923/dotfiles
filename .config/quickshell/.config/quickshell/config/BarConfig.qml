// qml/Configuration/Bar.qml
import Quickshell.Io

JsonObject {
    property Workspaces workspaces: Workspaces {}
    property Clock clock: Clock {}
    property int height: 50

    component Clock: JsonObject {
        property bool enabled: true
        property string format: "AM-PM"
    }

    component Workspaces: JsonObject {
        property int shown: 5
    }
}
