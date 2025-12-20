import Quickshell.Io
import Quickshell

JsonObject {

    property string wallpaperPath: `${Quickshell.env("HOME")}/.config/quickshell/assets/fallback.png`

    property Parallax parallax: Parallax {}

    property Dim dim: Dim {}

    component Dim: JsonObject {
        property bool enabled: true
        property real transparency: 0.25
    }

    component Parallax: JsonObject {
        property bool enabled: true
        property real wallpaperScale: 1.1
    }
}
