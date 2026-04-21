import Quickshell.Io
import Quickshell

JsonObject {

    property string wallpaperPath: ""

    property Parallax parallax: Parallax {}
    property Zoom zoom: Zoom {}

    property Dim dim: Dim {}

    property Wallhaven wallhaven: Wallhaven {}
    property Konachan konachan: Konachan {}

    component Dim: JsonObject {
        property bool enabled: true
        property real opacity: 0.25
    }

    component Parallax: JsonObject {
        property bool enabled: true
        property real wallpaperScale: 1.1
    }

    component Zoom: JsonObject  {
        property bool enabled: true
        property real scale: 1.1
    }

    component Wallhaven: JsonObject {
        property string query: ""
        property string sorting: "random"
        property string categories: "111" // General/Anime/People (1 or 0 for each)
        property string purity: "100" // 100 = SFW, 110 = SFW + Sketchy
        property string ratios: "16x9,16x10"
        property string apiKey: ""
    }

    component Konachan: JsonObject {
        property string tags: ""      // tags
        property string rating: "s"    // s = safe, q = questionable, e = explicit
        property int limit: 500        // limit for random
    }
}
