// qml/Configuration/Bar.qml
import Quickshell.Io

// Этот файл определяет структуру для раздела "bar" в твоем config.json
JsonObject {
    // --- Общие настройки бара ---
    // property bool persistent: true
    // property bool showOnHover: true
    // property int dragThreshold: 20

    // --- Вложенные группы настроек ---
    // property ScrollActions scrollActions: ScrollActions {}
    // property Popouts popouts: Popouts {}
    property Workspaces workspaces: Workspaces {}
    // property Tray tray: Tray {}
    // property Status status: Status {}
    property Clock clock: Clock {}

    component Clock: JsonObject {
        property bool enabled: true
        property string format: "AM-PM"
    }

    component Workspaces: JsonObject {
        property int shown: 5
    }

    // property Sizes sizes: Sizes {}

    // --- Динамическая структура самого бара ---
    // property list<var> entries: [
    //     // { "id": "logo", "enabled": true },
    //     // { "id": "workspaces", "enabled": true },
    //     // { "id": "spacer", "enabled": true },
    //     // { "id": "activeWindow", "enabled": true },
    //     // { "id": "spacer", "enabled": true },
    //     // { "id": "tray", "enabled": true },
    //     {
    //         "id": "clock",
    //         "enabled": true
    //     }
    //     // { "id": "statusIcons", "enabled": true },
    //     // { "id": "power", "enabled": true }
    //     ,
    // ]

    // --- Шаблоны для вложенных групп (внутренние компоненты) ---
    // component ScrollActions: JsonObject {
    //     property bool workspaces: true
    //     property bool volume: true
    //     property bool brightness: true
    // }

    // component Popouts: JsonObject {
    //     property bool activeWindow: true
    //     property bool tray: true
    // }

    // ... и остальные компоненты из примера ...
    // component Workspaces: /* ... */ JsonObject {}
    // component Tray: /* ... */ JsonObject {}
    // component Status: /* ... */ JsonObject {}
    // component Sizes: /* ... */ JsonObject {}
}
