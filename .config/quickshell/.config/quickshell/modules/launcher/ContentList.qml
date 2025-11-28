import QtQuick
import Quickshell
import qs.modules.common
import qs.utils
import qs.services

Item {
    id: root

    required property real maxHeight
    required property string search
    property bool showWallpaper: search.startsWith(":wallpaper")
    readonly property Item currentList: appList.item // Добавьте это свойство

    // anchors.fill: parent
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top

    state: showWallpaper ? "wallpapers" : "apps"

    states: [
        State {
            name: "apps"

            PropertyChanges {
                root.implicitHeight: Math.min(root.maxHeight, appList.implicitHeight > 0 ? appList.implicitHeight : empty.implicitHeight)
                appList.active: true
            }
        },
        State {
            name: "wallpapers"

            PropertyChanges {
                wallpapersList.active: true
            }
        }
    ]

    Loader {
        id: appList

        active: false

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        sourceComponent: AppList {
            search: root.search
        }
    }

    Loader {
        id: wallpapersList

        sourceComponent: Item {}
    }

    Row {
        id: empty

        opacity: root.currentList?.count === 0 ? 1 : 0
        scale: root.currentList?.count === 0 ? 1 : 0.5

        spacing: Appearance.spacing.normal
        padding: Appearance.padding.large

        anchors.horizontalCenter: parent.horizontalCenter
        // anchors.verticalCenter: parent.verticalCenter

        anchors.centerIn: parent

        MaterialSymbol { // Используйте MaterialSymbol, так как MaterialIcon не был предоставлен в вашем коде
            icon: root.state === "wallpapers" ? "wallpaper_slideshow" : "manage_search"
            color: Colors.palette.m3onSurfaceVariant
            size: 23

            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            StyledText {
                text: root.state === "wallpapers" ? "No wallpapers found" : "No results"
                color: Colors.palette.m3onSurface
                weight: 500
            }

            StyledText {
                text: root.state === "wallpapers" ? "Try putting some wallpapers" : "Try searching for something else"
                color: Colors.palette.m3onSurface
                size: 20
            }
        }

        Behavior on opacity {
            // Добавьте анимацию, если необходимо, как в референсном коде
        }

        Behavior on scale {
            // Добавьте анимацию, если необходимо, как в референсном коде
        }
    }
}
