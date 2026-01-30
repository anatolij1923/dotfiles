import Quickshell.Io

JsonObject {
    property Sizes sizes: Sizes {}
    property int maxShown: 8

    component Sizes: JsonObject {
        property int itemHeight: 60
        property int wallWidth: 350
        property int wallHeight: 230
    }

    property list<var> commands: [
        {
            name: "Hello",
            description: "Just say hello!",
            icon: "waving_hand",
            action: ["notify-send", "-a", "shell", "Welcome!", "Hello from Quickshell"]
        },
        {
            name: "Wallpaper",
            description: "Open wallpaper selector",
            icon: "wallpaper",
            action: ["autocomplete", "wallpaper"]
        },
        {
            name: "Clipboard",
            description: "Open clipboard",
            icon: "content_paste_search",
            action: ["autocomplete", "clipboard"]
        },
        {
            name: "Calculator",
            description: "Do some math",
            icon: "calculate",
            action: ["autocomplete", "calculate"]
        },
        {
            name: "Emoji",
            description: "Open emoji list",
            icon: "mood",
            action: ["autocomplete", "emoji"]
        },
    ]
}
