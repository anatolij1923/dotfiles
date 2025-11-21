import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.services
import qs.modules.common
import qs.modules.launcher.items

Scope {
    id: root
    property string searchingText: ""
    property bool showResults: searchingText.trim().length > 0
    property var customCommands: [
        {
            id: "wallpaper",
            name: "Change Wallpaper",
            description: "Open wallpaper selector",
            icon: "preferences-desktop-wallpaper" // Используем иконку из стандартной темы
            ,
            action: () => {
                // Здесь будет логика открытия твоего WallpaperSelector
                console.log("TODO: Open wallpaper selector window");
            }
        },
        {
            id: "settings",
            name: "Settings",
            description: "Open shell settings",
            icon: "preferences-system",
            action: () => {
                console.log("TODO: Open settings window");
            }
        },
        {
            id: "reboot",
            name: "Reboot",
            description: "Reboot the system",
            icon: "system-reboot",
            action: () => {
                Quickshell.execDetached({
                    command: ["systemctl", "reboot"]
                });
            }
        }
    ]

    PanelWindow {
        id: launcherRoot
        visible: GlobalStates.launcherOpened
        anchors.top: true
        margins.top: 40
        exclusiveZone: 0
        color: "transparent"

        implicitWidth: contentLoader.item ? contentLoader.item.implicitWidth : 460
        implicitHeight: contentLoader.item ? contentLoader.item.implicitHeight : 40

        // Behavior on implicitHeight {
        //     Anim {
        //         duration: Appearance.animDuration.expressiveSlowSpatial
        //         easing.bezierCurve: Appearance.animCurves.expressiveSlowSpatial
        //     }
        // }

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

        Loader {
            id: contentLoader
            anchors.fill: parent
            active: GlobalStates.launcherOpened
            focus: GlobalStates.launcherOpened

            sourceComponent: Rectangle {
                id: wrapper
                color: Colors.palette.m3surface
                radius: 24
                implicitWidth: 460

                border.width: 1
                border.color: Colors.palette.m3surfaceContainerHigh

                property int itemHeight: 40
                property int maxListHeight: 350

                implicitHeight: searchField.implicitHeight + (root.showResults ? (content.spacing + 1 + content.spacing + Math.min(resultsView.contentHeight, maxListHeight)) : 0) + content.spacing

                ColumnLayout {
                    id: content
                    anchors.fill: parent
                    spacing: 6

                    Keys.onPressed: event => {
                        switch (event.key) {
                        case Qt.Key_Escape:
                            launcherRoot.hide();
                            event.accepted = true;
                            break;
                        case Qt.Key_Up:
                        case Qt.Key_Backtab:
                            resultsView.decrementCurrentIndex();
                            event.accepted = true;
                            break;
                        case Qt.Key_Down:
                        case Qt.Key_Tab:
                            resultsView.incrementCurrentIndex();
                            event.accepted = true;
                            break;
                        case Qt.Key_Return:
                        case Qt.Key_Enter:
                            if (resultsView.currentIndex >= 0 && resultsView.count > 0) {
                                resultsView.model[resultsView.currentIndex].execute();
                                launcherRoot.hide();
                                event.accepted = true;
                            }
                            break;
                        }
                    }

                    // Text field
                    StyledTextField {
                        id: searchField
                        Layout.fillWidth: true
                        // implicitHeight: 56
                        focus: true
                        icon: "search"
                        placeholderText: "Search..."
                        font.pixelSize: 20
                        onTextChanged: root.searchingText = text
                        background: Rectangle {
                            color: "transparent"
                        }
                    }

                    // Separator

                    // Results list
                    ListView {
                        id: resultsView
                        visible: root.showResults && count > 0
                        Layout.fillWidth: true
                        height: Math.min(contentHeight, wrapper.maxListHeight)
                        clip: true
                        model: AppSearch.fuzzyQuery(root.searchingText).slice(0, 15)
                        // model: ScriptModel {
                        //
                        //     values: {
                        //         if (root.searchingText.startsWith(":")) {
                        //             const query = root.searchingText.substring(1).toLowerCase();
                        //             const filteredCommands = root.customCommands.filter(cmd => cmd.name.toLowerCase().includes(query));
                        //
                        //             return filteredCommands.map(cmd => ({
                        //                         type: "command",
                        //                         data: cmd
                        //                     }));
                        //         } else {
                        //             return AppSearch.fuzzyQuery(root.searchingText).slice(0, 15);
                        //         }
                        //     }
                        // }

                        // return text.startsWith(":")
                        //     ?
                        spacing: 2
                        currentIndex: 0
                        focus: true
                        ScrollBar.vertical: ScrollBar {}
                        leftMargin: 8
                        rightMargin: 8
                        bottomMargin: 8

                        highlight: Rectangle {
                            color: Colors.palette.m3secondaryContainer
                            radius: Appearance.rounding.normal

                            y: root.currentIndex?.y ?? 0

                            Behavior on y {
                                Anim {
                                    duration: Appearance.animDuration.expressiveDefaultSpatial
                                    easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                                }
                            }
                        }

                        delegate: AppItem {
                            desktopEntry: modelData
                            isCurrent: resultsView.currentIndex === index
                            onActivated: launcherRoot.hide()
                        }

                        Keys.forwardTo: [searchField]
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
    }

    Component.onCompleted: {
        AppSearch.fuzzyQuery("");
    }
}
