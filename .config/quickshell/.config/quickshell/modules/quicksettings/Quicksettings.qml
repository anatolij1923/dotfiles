import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs
import qs.services

Scope {
    PanelWindow {
        id: quicksettingsRoot
        function hide() {
            GlobalStates.quicksettingsOpened = false;
        }
        visible: GlobalStates.quicksettingsOpened

        color: "transparent"
        implicitWidth: Appearance.sizes.quicksettingsWidth

        anchors {
            top: true
            right: true
            bottom: true
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

        Loader {
            active: GlobalStates.quicksettingsOpened
            anchors {
                fill: parent
                margins: 16
            }

            focus: GlobalStates.quicksettingsOpened
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    quicksettingsRoot.hide();
                }
            }

            sourceComponent: QuicksettingsContent {}
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
