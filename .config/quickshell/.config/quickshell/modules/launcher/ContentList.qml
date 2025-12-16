pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.modules.common
import qs.utils
import qs.services
import qs.modules.launcher

Item {
    id: root

    required property real maxHeight
    required property string search
    property var searchField
    property bool showCommands: search.startsWith(":")
    property bool showWallpaper: search.startsWith(":wallpaper")
    property bool showCalc: !showCommands && !showWallpaper && isMathExpression(search)
    readonly property Item currentList: showCalc ? calcResult.item : (showWallpaper ? wallpapersList.item : (showCommands ? commandsList.item : appList.item))

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    state: showCalc ? "calc" : (showWallpaper ? "wallpapers" : (showCommands ? "commands" : "apps"))

    states: [
        State {
            name: "apps"

            PropertyChanges {
                root.implicitHeight: Math.min(root.maxHeight, appList.implicitHeight > 0 ? appList.implicitHeight : empty.implicitHeight)
                appList.active: true
            }
        },
        State {
            name: "commands"

            PropertyChanges {
                root.implicitHeight: Math.min(root.maxHeight, commandsList.implicitHeight > 0 ? commandsList.implicitHeight : empty.implicitHeight)
                commandsList.active: true
            }
        },
        State {
            name: "wallpapers"

            PropertyChanges {
                root.implicitHeight: Math.min(root.maxHeight, wallpapersList.implicitHeight > 0 ? wallpapersList.implicitHeight : empty.implicitHeight)
                wallpapersList.active: true
            }
        },
        State {
            name: "calc"

            PropertyChanges {
                root.implicitHeight: Math.min(
                    root.maxHeight,
                    calcResult.item && calcResult.item.implicitHeight > 0
                        ? calcResult.item.implicitHeight
                        : empty.implicitHeight
                )
                calcResult.active: true
            }
        }
    ]

    function isMathExpression(text) {
        const trimmed = text.trim();
        if (trimmed.length === 0)
            return false;
        // Only allow digits, operators, spaces, dot and parentheses
        const mathOnly = /^[\d\.\s\+\-\*\/\^%()]+$/.test(trimmed);
        console.log("[ContentList] isMathExpression:", JSON.stringify(trimmed), "mathOnly:", mathOnly, "hasDigit:", /\d/.test(trimmed));
        if (!mathOnly)
            return false;
        return /\d/.test(trimmed);
    }

    Loader {
        id: appList

        active: false

        anchors.fill: parent
        // anchors.top: parent.top
        // anchors.horizontalCenter: parent.horizontalCenter

        sourceComponent: AppList {
            search: root.search
        }
    }

    Loader {
        id: commandsList

        active: false

        anchors.fill: parent

        sourceComponent: CommandList {
            search: root.search
            searchField: root.searchField
        }
    }

    Loader {
        id: wallpapersList

        active: false

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        sourceComponent: WallpaperList {
            search: root.search
            maxHeight: root.maxHeight
        }
    }

    Loader {
        id: calcResult

        active: false

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        sourceComponent: CalcResult {
            expression: root.search
        }

        onLoaded: {
            console.log("[ContentList] CalcResult loaded. item:", calcResult.item, "implicitHeight:", calcResult.item && calcResult.item.implicitHeight);
        }
    }

    Row {
        id: empty

        opacity: root.currentList?.count === 0 ? 1 : 0
        scale: root.currentList?.count === 0 ? 1 : 0.5

        spacing: Appearance.padding.normal
        padding: Appearance.padding.large

        anchors.fill: parent

        MaterialSymbol {
            icon: "sentiment_sad"
            // icon: {
            //     if (root.state === "wallpapers") return "wallpaper_slideshow";
            //     if (root.state === "commands") return "terminal";
            //     return "sentiment_sad";
            // }
            color: Colors.palette.m3onSurfaceVariant
            size: 48

            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            StyledText {
                text: {
                    if (root.state === "wallpapers")
                        return "No wallpapers found";
                    if (root.state === "commands")
                        return "No commands found";
                    return "No results";
                }
                color: Colors.palette.m3onSurface
                weight: 500
            }

            StyledText {
                text: {
                    if (root.state === "wallpapers")
                        return "Smart man in glasses download wallpaper";
                    if (root.state === "commands")
                        return "Try searching for a different command";
                    return "Try something else";
                }
                color: Colors.palette.m3onSurface
                size: 20
            }
        }

        Behavior on opacity {}

        Behavior on scale {}
    }
}
