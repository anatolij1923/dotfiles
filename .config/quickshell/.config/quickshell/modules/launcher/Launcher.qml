import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs
import qs.config
import qs.services
import qs.modules.common

Scope {
    id: root

    Loader {
        active: GlobalStates.launcherOpened

        sourceComponent: PanelWindow {
            id: launcherRoot
            visible: GlobalStates.launcherOpened

            implicitWidth: 400
            implicitHeight: searchWrapper.implicitHeight

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

            Item {
                id: wrapper
                anchors.fill: parent

                Rectangle {
                    id: searchWrapper

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    implicitHeight: Math.max(icon.implicitHeight, searchField.implicitHeight)

                    MaterialSymbol {
                        id: icon
                        icon: "search"

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    StyledTextField {
                        id: searchField
                        focus: true

                        onAccepted: {}

                        Keys.onEscapePressed: launcherRoot.hide()

                        anchors {
                            left: icon.right
                            right: parent.right
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
    }
}
