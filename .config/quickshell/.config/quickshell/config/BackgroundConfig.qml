import Quickshell.Io

JsonObject {

    property string wallpaperPath: ""

    property Parallax parallax: Parallax {}

    property Dim dim: Dim {}

    component Dim: JsonObject {
        property bool enabled: true
        property real transparency: 0.4
    }

    component Parallax: JsonObject {
        property bool enabled: true
        property real wallpaperScale: 1.1
    }
}
