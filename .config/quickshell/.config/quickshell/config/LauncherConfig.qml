import Quickshell.Io

JsonObject {
    property Sizes sizes: Sizes {}
    property int maxShown: 8
    property int wallsShown: 12
    property string actionPrefix: ":"

    component Sizes: JsonObject {
        property int itemHeight: 60
        property int wallWidth: 250
        property int wallHeight: 150
    }

    property list<var> commands: [
        {
            name: "Hello",
            description: "Just say hello!",
            icon: "waving_hand",
            action: ["notify-send", "Hello from Quickshell!"]
        },
        {
            name: "Wallpaper",
            description: "Open wallpaper selector",
            icon: "wallpaper",
            action: ["autocomplete", "wallpaper"]
        },
        {
            name: "Update",
            description: "Update your system",
            icon: "upgrade",
            action: ["wezterm", "-e", "yay"]
        }
    ]
}
