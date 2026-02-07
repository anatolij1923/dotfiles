import QtQuick

ListModel {
    ListElement {
        pageId: "appearance"
        textKey: "settings.sidebar.appearance"
        icon: "palette"
    }
    ListElement {
        pageId: "general"
        textKey: "settings.sidebar.general"
        icon: "settings"
    }
    ListElement {
        pageId: "launcher"
        textKey: "settings.sidebar.launcher"
        icon: "apps"
    }
    ListElement {
        pageId: "system"
        textKey: "settings.sidebar.system"
        icon: "manufacturing"
    }
    ListElement {
        pageId: "about"
        textKey: "settings.sidebar.about"
        icon: "info"
    }
}
