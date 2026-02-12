pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import qs
import qs.config
import qs.services
import qs.common
import qs.widgets

Scope {
    id: root
    property int padding: Appearance.spacing.lg
    property int rounding: Appearance.rounding.xxl
    property string searchingText: ""

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    Loader {
        active: GlobalStates.launcherOpened

        sourceComponent: StyledWindow {
            id: launcherRoot
            name: "launcher"

            anchors {
                left: true
                right: true
                top: true
                bottom: true
            }

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

            visible: GlobalStates.launcherOpened
            color: "transparent"

            function hide() {
                GlobalStates.launcherOpened = false;
                root.searchingText = "";
            }

            MouseArea {
                anchors.fill: parent
                onClicked: launcherRoot.hide()
                z: -1
            }

            HyprlandFocusGrab {
                windows: [launcherRoot]
                active: GlobalStates.launcherOpened
                onCleared: if (!active)
                    launcherRoot.hide()
            }

            Item {
                id: mainContainer
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Appearance.spacing.xl

                property real maxHeight: launcherRoot.screen.height * 0.8

                // Dynamic width for different modes
                width: {
                    if (root.searchingText.startsWith(":wallpaper")) {
                        // Wide enough to show carousel with side items
                        return launcherRoot.screen.width * 0.7;
                    }
                    return launcherRoot.screen.width * 0.3;
                }

                height: Math.min(maxHeight, searchWrapper.implicitHeight + listWrapper.implicitHeight + root.padding * 2) + root.padding

                Behavior on width {
                    Anim {
                        duration: Appearance.animDuration.expressiveDefaultSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                    }
                }

                Behavior on height {
                    Anim {
                        duration: Appearance.animDuration.expressiveDefaultSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                    }
                }

                Rectangle {
                    id: background
                    anchors.fill: parent
                    color: root.transparent ? Qt.alpha(Colors.palette.m3surface, root.alpha) : Colors.palette.m3surface
                    radius: root.rounding
                    smooth: true
                    border {
                        width: 1
                        color: Colors.palette.border
                    }

                    clip: true

                    Item {
                        id: wrapper
                        anchors.fill: parent

                        Rectangle {
                            id: searchWrapper
                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                margins: root.padding
                            }
                            implicitHeight: Math.max(icon.implicitHeight, searchField.implicitHeight)
                            radius: Appearance.rounding.xxl
                            color: root.transparent ? Qt.alpha(Colors.palette.m3surfaceContainer, root.alpha) : Colors.palette.m3surfaceContainer

                            MaterialSymbol {
                                id: icon
                                weight: 600
                                icon: "search"
                                color: Colors.palette.m3onSurfaceVariant
                                anchors {
                                    left: parent.left
                                    verticalCenter: parent.verticalCenter
                                    leftMargin: root.padding
                                }
                            }

                            StyledTextField {
                                id: searchField
                                focus: true
                                background: null

                                anchors {
                                    left: icon.right
                                    right: modeIcon.left
                                    rightMargin: root.padding
                                }

                                text: root.searchingText
                                topPadding: Appearance.spacing.lg
                                bottomPadding: Appearance.spacing.lg
                                placeholderText: `Search or run commands with ":"`
                                fontSize: 20
                                fontWeight: 500
                                placeholderTextColor: Colors.palette.m3outline

                                onTextChanged: {
                                    if (root.searchingText !== text) {
                                        root.searchingText = text;
                                    }
                                }

                                onAccepted: {
                                    const list = contentList.currentList;

                                    if (list && typeof list.activate === "function") {
                                        if (list.activate()) {
                                            launcherRoot.hide();
                                        }
                                    }
                                }

                                Keys.onEscapePressed: launcherRoot.hide()
                                Keys.onUpPressed: contentList.currentList?.decrementCurrentIndex()
                                Keys.onDownPressed: contentList.currentList?.incrementCurrentIndex()

                                Keys.onPressed: event => {
                                    // Tab navigation
                                    //
                                    const isCtrl = event.modifiers & Qt.ControlModifier;

                                    if (event.key === Qt.Key_Tab || (isCtrl && event.key === Qt.Key_J)) {
                                        contentList.currentList?.incrementCurrentIndex();
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Backtab || (isCtrl && event.key === Qt.Key_K)) {
                                        contentList.currentList?.decrementCurrentIndex();
                                        event.accepted = true;
                                    } else
                                    // Carousel navigation for wallpapers
                                    if (contentList.showWallpaper) {
                                        // if (event.key === Qt.Key_Left) {
                                        //     contentList.currentList?.decrementCurrentIndex();
                                        //     event.accepted = true;
                                        // } else if (event.key === Qt.Key_Right) {
                                        //     contentList.currentList?.incrementCurrentIndex();
                                        //     event.accepted = true;
                                        // }
                                    }
                                }
                            }

                            MaterialSymbol {
                                id: modeIcon
                                anchors {
                                    right: parent.right
                                    verticalCenter: parent.verticalCenter
                                    rightMargin: root.padding
                                }
                                icon: {
                                    if (contentList.showWallpaper)
                                        return "wallpaper";
                                    if (contentList.showEmoji)
                                        return "mood";
                                    if (contentList.showClipboard)
                                        return "content_paste_search";
                                    if (contentList.showCalc)
                                        return "calculate";
                                    if (contentList.showCommands)
                                        return "terminal";
                                    if (contentList.showCalc)
                                        return "calculate";
                                    return "apps";
                                }
                                color: Colors.palette.m3onSurfaceVariant
                            }
                        }

                        Item {
                            id: listWrapper
                            implicitHeight: contentList.height
                            clip: true
                            anchors {
                                top: searchWrapper.bottom
                                left: parent.left
                                right: parent.right
                                margins: root.padding
                            }

                            ContentList {
                                id: contentList
                                maxHeight: mainContainer.maxHeight - searchWrapper.height - root.padding * 3
                                search: root.searchingText
                                searchField: searchField
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            GlobalStates.launcherOpened = !GlobalStates.launcherOpened;
        }
        function open(): void {
            GlobalStates.launcherOpened = true;
        }
        function close(): void {
            GlobalStates.launcherOpened = false;
        }

        function openInWallMode(): void {
            root.searchingText = ":wallpaper ";
            GlobalStates.launcherOpened = true;
        }
        function openInClipboardMode(): void {
            root.searchingText = ":clipboard ";
            GlobalStates.launcherOpened = true;
        }
        function openInEmojisMode(): void {
            root.searchingText = ":emoji ";
            GlobalStates.launcherOpened = true;
        }
    }

    GlobalShortcut {
        name: "toggleLauncher"
        description: "Open launcher window"
        onPressed: {
            GlobalStates.launcherOpened = !GlobalStates.launcherOpened;
        }
    }

    GlobalShortcut {
        name: "launcherWallMode"
        description: "Open launcher in wallpaper mode"
        onPressed: {
            root.searchingText = ":wallpaper ";
            GlobalStates.launcherOpened = true;
        }
    }

    GlobalShortcut {
        name: "launcherClipboardMode"
        description: "Open launcher in clipboard mode"
        onPressed: {
            root.searchingText = ":clipboard ";
            GlobalStates.launcherOpened = true;
        }
    }

    GlobalShortcut {
        name: "launcherEmojiMode"
        description: "Open launcher in emoji mode"
        onPressed: {
            root.searchingText = ":emoji ";
            GlobalStates.launcherOpened = true;
        }
    }

    Connections {
        target: GlobalStates
        function onLauncherOpenedChanged() {
            // GlobalStates.quicksettingsOpened = false;
            // GlobalStates.overviewOpened = false;
            // GlobalStates.powermenuOpened = false;
            if (!GlobalStates.launcherOpened)
                root.searchingText = "";
        }
    }

    Component.onCompleted: {
        AppSearch.fuzzyQuery("");
    }
}
