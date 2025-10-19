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

Scope {
    id: root
    property string searchingText: ""
    property bool showResults: searchingText.trim().length > 0

    PanelWindow {
        id: launcherRoot
        visible: GlobalStates.launcherOpened
        anchors.top: true
        margins.top: 40
        exclusiveZone: 0
        color: "transparent"

        implicitWidth: contentLoader.item ? contentLoader.item.implicitWidth : 460
        implicitHeight: contentLoader.item ? contentLoader.item.implicitHeight : 40

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
                color: Colors.surface
                radius: 24
                implicitWidth: 460

                border.width: 1
                border.color: Colors.surface_container_high

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
                        spacing: 2
                        currentIndex: 0
                        focus: true
                        ScrollBar.vertical: ScrollBar {}
                        leftMargin: 8
                        rightMargin: 8
                        bottomMargin: 8

                        delegate: LauncherItem {
                            desktopEntry: modelData
                            isCurrent: resultsView.currentIndex === index
                            onActivated: launcherRoot.hide()
                        }

                        Keys.forwardTo: [searchField]
                    }
                }
            }
        }

        // ────────────────────────────── IPC ──────────────────────────────
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
        AppSearch.fuzzyQuery("")
    }
}
