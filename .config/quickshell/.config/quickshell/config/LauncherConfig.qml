import Quickshell.Io

JsonObject {
    property Sizes sizes: Sizes {}
    property int maxShown: 10
    property int wallsShown: 9
    property string actionPrefix: ":"

    component Sizes: JsonObject {
        property int itemHeight: 60
        property int wallWidth: 250
        property int wallHeight: 200
    }

    property list<var> command: [
        {
            name: "Hello",
            description: "Just say hello!",
            icon: "waving_hand",
            action: ["notify-send", "Hello from Quickshell!"]
        }
    ]
}
