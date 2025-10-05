import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.services

Scope {
    id: root
    Loader {
        id: powerMenuLoader
        active: GlobalStates.powerMenuOpened

        sourceComponent: PanelWindow {
            id: powermenuRoot
            visible: powerMenuLoader.active

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            function hide() {
                GlobalStates.powerMenuOpened = false;
            }
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    powermenuRoot.hide();
                }
            }

            Rectangle {
                id: powerMenuContent
                anchors.centerIn: parent
                implicitWidth: buttonsRow.implicitWidth + 50
                implicitHeight: buttonsRow.implicitHeight + 50
                radius: 32
                color: Colors.surface

                RowLayout {
                    id: buttonsRow
                    anchors.centerIn: parent

                    PowermenuButton {
                        buttonIcon: "lock"
                        buttonText: "Lock"
                        focus: true
                        onClicked: {
                            Session.lock();
                            powermenuRoot.hide();
                        }
                    }
                    PowermenuButton {
                        buttonIcon: "power_settings_new"
                        buttonText: "Shutdown"
                        onClicked: {
                            Session.poweroff();
                            powermenuRoot.hide();
                        }
                    }
                    PowermenuButton {
                        buttonIcon: "bedtime"
                        buttonText: "Suspend"
                        onClicked: {
                            Session.suspend();
                            powermenuRoot.hide();
                        }
                    }
                    PowermenuButton {
                        buttonIcon: "refresh"
                        buttonText: "Restart"
                        onClicked: {
                            Session.reboot();
                            powermenuRoot.hide();
                        }
                    }
                    PowermenuButton {
                        buttonIcon: "exit_to_app"
                        buttonText: "Logout"
                        onClicked: {
                            Session.logout();
                            powermenuRoot.hide();
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "powermenu"

        function toggle(): void {
            GlobalStates.powerMenuOpened = !GlobalStates.powerMenuOpened;
        }

        function close(): void {
            GlobalStates.powerMenuOpened = false;
        }

        function open(): void {
            GlobalStates.powerMenuOpened = true;
        }
    }

    GlobalShortcut {
        name: "powerMenuToggle"
        description: "Toggles session screen on press"

        onPressed: {
            GlobalStates.powerMenuOpened = !GlobalStates.powerMenuOpened;
        }
    }

    GlobalShortcut {
        name: "powerMenuOpen"
        description: "Opens session screen on press"

        onPressed: {
            GlobalStates.powerMenuOpened = true;
        }
    }

    GlobalShortcut {
        name: "powerMenuClose"
        description: "Closes session screen on press"

        onPressed: {
            GlobalStates.powerMenuOpened = false;
        }
    }
}
