import Quickshell.Io

JsonObject {

    property string wallpaperPath: ""

    property Parallax parallax: Parallax {}

    component Parallax: JsonObject {
        property bool enabled: true
        property real wallpaperScale: 1.1 
    }
}
