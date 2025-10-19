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
    PanelWindow {
        id: powermenuRoot
        visible: GlobalStates.powerMenuOpened

        color: "transparent"
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        function hide() {
            GlobalStates.powerMenuOpened = false;
        }

        HyprlandFocusGrab {
            windows: [powermenuRoot]
            active: GlobalStates.powerMenuOpened
            onCleared: () => {
                powermenuRoot.hide();
            }
        }

        Loader {
            active: GlobalStates.powerMenuOpened
            anchors {
                // fill: parent
                centerIn: parent
            }
            focus: GlobalStates.powerMenuOpened

            sourceComponent: Rectangle {
                id: powerMenuContent
                anchors.centerIn: parent
                implicitWidth: buttonsRow.implicitWidth + 50
                implicitHeight: buttonsRow.implicitHeight + 50
                radius: 32
                color: Colors.surface
                focus: true // Ensure the content itself is focusable

                // Add a property to keep track of the currently focused button index
                property int focusedButtonIndex: 0

                // Function to move focus to the next button
                function focusNext() {
                    let nextIndex = (focusedButtonIndex + 1) % buttonsRow.children.length;
                    buttonsRow.children[nextIndex].forceActiveFocus();
                    focusedButtonIndex = nextIndex;
                }

                // Function to move focus to the previous button
                function focusPrevious() {
                    let prevIndex = (focusedButtonIndex - 1 + buttonsRow.children.length) % buttonsRow.children.length;
                    buttonsRow.children[prevIndex].forceActiveFocus();
                    focusedButtonIndex = prevIndex;
                }

                Component.onCompleted: {
                    // Set initial focus to the first button
                    if (buttonsRow.children.length > 0) {
                        buttonsRow.children[0].forceActiveFocus();
                        focusedButtonIndex = 0;
                    }
                }

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        powermenuRoot.hide();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Backtab) {
                        powerMenuContent.focusPrevious();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Tab) {
                        powerMenuContent.focusNext();
                        event.accepted = true;
                    }
                }

                RowLayout {
                    id: buttonsRow
                    anchors.centerIn: parent

                    PowermenuButton {
                        buttonIcon: "lock"
                        buttonText: "Lock"
                        onClicked: () => {
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
        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: powermenuRoot.hide()
        // }
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
