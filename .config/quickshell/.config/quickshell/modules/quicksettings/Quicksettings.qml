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
            }

            implicitWidth: {
                const sw = quicksettingsRoot.screen.width;

                if (sw < 1100)
                    return 300;
                if (sw < 1600)
                    return 400;
                if (sw < 2200)
                    return 500;
                return 650;
            }

            exclusiveZone: 0

            HyprlandFocusGrab {
                windows: [quicksettingsRoot]
                active: GlobalStates.quicksettingsOpened
                onCleared: if (!active)
                    quicksettingsRoot.hide()
            }

            Connections {
                target: GlobalStates
            }

            QuicksettingsContent {
                focus: true
                Keys.onEscapePressed: quicksettingsRoot.hide()
                anchors {
                    fill: parent
                    margins: Appearance.spacing.md
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

    GlobalShortcut {
        name: "openQuicksettings"
        description: "Open quicksettings window"

        onPressed: {
            GlobalStates.quicksettingsOpened = !GlobalStates.quicksettingsOpened;
        }
    }
}
