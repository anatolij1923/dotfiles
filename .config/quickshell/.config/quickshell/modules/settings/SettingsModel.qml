import QtQuick

ListModel {
    ListElement {
        pageId: "appearance"
        textKey: "settings.sidebar.appearance"
        icon: "palette"
    }
    ListElement {
        pageId: "bar"
        textKey: "Bar"
        icon: "toolbar"
    }
    ListElement {
        pageId: "background"
        textKey: "Background"
        icon: "image"
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
