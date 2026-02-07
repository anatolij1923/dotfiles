pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs
import qs.common
import qs.widgets
import qs.services

Scope {
    Loader {
        active: GlobalStates.quicksettingsOpened
        sourceComponent: StyledWindow {
            id: quicksettingsRoot

            name: "quicksettings"
            function hide() {
                GlobalStates.quicksettingsOpened = false;
            }

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

            color: "transparent"

            anchors {
                top: true
                right: true
                bottom: true
                left: true
            }
            exclusiveZone: 0

            HyprlandFocusGrab {
                windows: [quicksettingsRoot]
                active: GlobalStates.quicksettingsOpened
                onCleared: () => {
                    if (!active)
                        quicksettingsRoot.hide();
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: quicksettingsRoot.hide()
            }

            Connections {
                target: GlobalStates

                // function onQuicksettingsOpenedChanged() {
                //     GlobalStates.launcherOpened = false;
                //     GlobalStates.overviewOpened = false;
                //     GlobalStates.powermenuOpened = false;
                // }
            }

            Loader {
                active: GlobalStates.quicksettingsOpened
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    margins: 16
                }

                focus: GlobalStates.quicksettingsOpened
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        quicksettingsRoot.hide();
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: mouse => mouse.accepted = true
                }

                sourceComponent: QuicksettingsContent {
                implicitWidth: {
                const sw = quicksettingsRoot.screen.width

                if (sw < 1100) return 300   
                if (sw < 1600) return 400   
                if (sw < 2200) return 500   
                return 650                  

                }
                // implicitWidth: Math.min(
                //     Math.max(quicksettingsRoot.screen.width * 0.25, 320),
                //     550
                // )
                }
            }

            
        }
    }

    IpcHandler {
        target: "quicksettings"

        function toggle(): void {
            GlobalStates.quicksettingsOpened = !GlobalStates.quicksettingsOpened;
        }
        function open(): void {
            GlobalStates.quicksettingsOpened = true;
        }
        function close(): void {
            GlobalStates.quicksettingsOpened = false;
        }
    }
}
