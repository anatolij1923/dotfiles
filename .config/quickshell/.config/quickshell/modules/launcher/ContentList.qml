pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.widgets
import qs.services
import qs.modules.launcher

Item {
    id: root

    required property real maxHeight
    required property string search
    property var searchField

    property bool showEmoji: search.startsWith(":emoji")
    property bool showCommands: search.startsWith(":")
    property bool showWallpaper: search.startsWith(":wallpaper")
    property bool showClipboard: search.startsWith(":clipboard")
    property bool showCalcExplicit: search.startsWith(":calculate")
    property bool showCalcAuto: !showCommands && !showWallpaper && !showEmoji && !showClipboard && isMathExpression(search)

    property bool showCalc: showCalcExplicit || showCalcAuto

    readonly property Item currentList: showCalc ? calcResult.item : (showWallpaper ? wallpapersList.item : (showClipboard ? clipboardList.item : (showEmoji ? emojiList.item : (showCommands ? commandsList.item : appList.item))))
    readonly property string calcSearchString: showCalcExplicit ? search.slice(11).trim() : search.trim()

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    state: showCalc ? "calc" : (showWallpaper ? "wallpapers" : (showClipboard ? "clipboard" : (showEmoji ? "emoji" : (showCommands ? "commands" : "apps"))))

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
            name: "clipboard"
            PropertyChanges {
                root.implicitHeight: Math.min(root.maxHeight, clipboardList.implicitHeight > 0 ? clipboardList.implicitHeight : empty.implicitHeight)
                clipboardList.active: true
            }
        },
        State {
            name: "emoji"
            PropertyChanges {
                root.implicitHeight: Math.min(root.maxHeight, emojiList.implicitHeight > 0 ? emojiList.implicitHeight : empty.implicitHeight)
                emojiList.active: true
            }
        },
        State {
            name: "calc"
            PropertyChanges {
                root.implicitHeight: Math.min(root.maxHeight, calcResult.item && calcResult.item.implicitHeight > 0 ? calcResult.item.implicitHeight : empty.implicitHeight)
                calcResult.active: true
            }
        }
    ]

    function isMathExpression(text) {
        const trimmed = text.trim();
        if (trimmed.length === 0)
            return false;
        const mathOnly = /^[\d\.\s\+\-\*\/\^%()]+$/.test(trimmed);
        if (!mathOnly)
            return false;
        return /\d/.test(trimmed);
    }

    Loader {
        id: appList
        active: false
        anchors.fill: parent
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
        id: clipboardList
        active: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        sourceComponent: ClipboardList {
            search: root.search
        }
    }

    Loader {
        id: calcResult
        active: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        sourceComponent: CalcResult {
            // Передаем очищенную строку
            expression: root.calcSearchString
        }
    }

    Loader {
        id: emojiList
        active: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        sourceComponent: EmojiList {
            search: root.search
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
                    if (root.state === "emoji")
                        return "No emojis found";
                    return "No results";
                }
                color: Colors.palette.m3onSurface
                weight: 500
            }

            StyledText {
                text: {
                    if (root.state === "wallpapers")
                        return `Try put some wallpapers in "~/Pictures/wallpapers" `;
                    if (root.state === "emoji")
                        return "Try searching for a different emoji name";
                    if (root.state === "clipboard") {
                        return "Nothing in clipboard";
                    }
                    return "Try something else";
                }
                color: Colors.palette.m3onSurface
                size: 20
            }
        }
        Behavior on opacity {
            Anim {}
        }
        Behavior on scale {
            Anim {}
        }
    }
}
