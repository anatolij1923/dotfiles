pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import qs
import qs.config
import qs.services
import qs.modules.common

// Based on https://github.com/caelestia-dots/shell with modifications

Scope {
    id: root
    property int padding: Appearance.padding.large
    property int rounding: Appearance.rounding.hugeass
    property string searchingText: ""

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    Loader {
        active: GlobalStates.launcherOpened

        sourceComponent: PanelWindow {
            id: launcherRoot
            property real maxHeight: screen.height * 0.8
            visible: GlobalStates.launcherOpened

            onVisibleChanged: {
                root.searchingText = "";
            }

            implicitWidth: {
                if (root.searchingText.startsWith(":wallpaper")) {
                    const wallWidth = Config.launcher.sizes.wallWidth;
                    const spacing = Appearance.padding.small;
                    const columns = 3;
                    return (wallWidth * columns) + (spacing * (columns - 1)) + (root.padding * 2);
                }
                return 550;
            }
            implicitHeight: Math.min(launcherRoot.maxHeight, searchWrapper.implicitHeight + listWrapper.implicitHeight + root.padding * 2) + root.padding

            // Behavior on implicitWidth {
            //     Anim {
            //         duration: 200
            //         easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            //     }
            // }
            color: "transparent"

            WlrLayershell.namespace: "quickshell:launcher"

            anchors {
                top: true
            }

            margins {
                top: Appearance.padding.huge
            }
            exclusiveZone: 0

            function hide() {
                GlobalStates.launcherOpened = false;
                root.searchingText = "";
            }

            HyprlandFocusGrab {
                windows: [launcherRoot]
                active: GlobalStates.launcherOpened
                onCleared: if (!active)
                    launcherRoot.hide()
            }

            Rectangle {
                id: background
                anchors.fill: parent
                color: root.transparent ? Qt.alpha(Colors.palette.m3surface, root.alpha) : Colors.palette.m3surface
                radius: root.rounding
                smooth: true
            }

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

                    radius: Appearance.rounding.hugeass
                    color: root.transparent ? Qt.alpha(Colors.palette.m3surfaceContainer, root.alpha) : Colors.palette.m3surfaceContainer

                    MaterialSymbol {
                        id: icon
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

                        onAccepted: {
                            const currentList = contentList.currentList;
                            if (!currentList) {
                                return;
                            }

                            const currentItem = currentList.currentItem;
                            if (!currentItem) {
                                return;
                            }

                            if (contentList.showWallpaper) {
                                const wallpaperPath = currentItem.wallpaperPath || currentItem.modelData;
                                if (wallpaperPath) {
                                    Wallpapers.setWallpaper(String(wallpaperPath));
                                    launcherRoot.hide();
                                }
                            } else if (contentList.showCommands) {
                                if (typeof currentItem.execute === "function") {
                                    currentItem.execute();
                                } else if (currentItem.modelData?.command) {
                                    const cmd = currentItem.modelData.command;
                                    if (cmd[0] === "autocomplete" && cmd.length > 1) {
                                        searchField.text = `:${cmd[1]} `;
                                    } else {
                                        Quickshell.execDetached(cmd);
                                        launcherRoot.hide();
                                    }
                                }
                            } else {
                                if (currentItem.modelData && typeof currentItem.modelData.execute === "function") {
                                    currentItem.modelData.execute();
                                    launcherRoot.hide();
                                }
                            }
                        }

                        Keys.onEscapePressed: launcherRoot.hide()
                        Keys.onUpPressed: contentList.currentList?.decrementCurrentIndex()
                        Keys.onDownPressed: contentList.currentList?.incrementCurrentIndex()

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Tab) {
                                contentList.currentList?.incrementCurrentIndex();
                            } else if (event.key === Qt.Key_Backtab) {
                                contentList.currentList?.decrementCurrentIndex();
                            }
                        }

                        anchors {
                            left: icon.right
                            right: parent.right
                            rightMargin: root.padding
                        }

                        topPadding: Appearance.padding.large
                        bottomPadding: Appearance.padding.large

                        placeholderText: `Search or run commands with ":"`

                        fontSize: 20
                        fontWeight: 400
                        placeholderTextColor: Colors.palette.m3outline

                        onTextChanged: root.searchingText = text
                    }

                    MaterialSymbol {
                        id: modeIcon
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: root.padding
                        }

                        icon: {
                            if (contentList.showWallpaper) {
                                return "wallpaper";
                            } else if (contentList.showCommands) {
                                return "terminal";
                            } else {
                                return "apps";
                            }
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
                        // bottom: parent.bottom
                        margins: root.padding
                    }

                    ContentList {
                        id: contentList
                        maxHeight: launcherRoot.maxHeight
                        search: root.searchingText
                        searchField: searchField
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
    }

    Component.onCompleted: {
        AppSearch.fuzzyQuery("");
    }
}
