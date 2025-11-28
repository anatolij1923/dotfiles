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
    property int padding: Appearance.padding.normal
    property int rounding: Appearance.rounding.normal

    Loader {
        active: GlobalStates.launcherOpened

        sourceComponent: PanelWindow {
            id: launcherRoot
            visible: GlobalStates.launcherOpened

            implicitWidth: 400
            implicitHeight: searchWrapper.height + root.padding * 2
            color: "transparent"

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
                        margins: root.padding
                    }
                    implicitHeight: Math.max(icon.implicitHeight, searchField.implicitHeight)

                    radius: Appearance.rounding.full
                    color: "red"

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
                            rightMargin: root.padding
                        }

                        topPadding: Appearance.padding.large
                        bottomPadding: Appearance.padding.large

                        placeholderText: `Search or run commands with ":"`

                        fontSize: 18
                        fontWeight: 400
                        placeholderTextColor: Colors.palette.m3outline
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
