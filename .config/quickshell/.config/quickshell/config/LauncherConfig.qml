import Quickshell.Io

JsonObject {
    property Sizes sizes: Sizes {}
    property int maxShown: 10
    property int wallsShown: 9

    component Sizes: JsonObject {
        property int itemHeight: 60
        property int wallWidth: 250
        property int wallHeight: 200
    }

    property list<var> commands: [
        {
            name: "",
            icon: "",
            action: [""]
        }
    ]
}
