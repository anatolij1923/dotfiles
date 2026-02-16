pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import qs.config
import qs.widgets
import qs.common
import qs.services
import qs

Scope {
    id: root
    property bool bottom: Config.bar.bottom

    Loader {
        active: GlobalStates.dashboardOpened

        sourceComponent: StyledWindow {
            id: dashRoot

            name: "dashboard"
            anchors {
                top: !root.bottom
                bottom: root.bottom
            }

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

            function hide() {
                GlobalStates.dashboardOpened = false;
            }

            HyprlandFocusGrab {
                windows: [dashRoot]
                active: GlobalStates.dashboardOpened
                onCleared: if (!active)
                    dashRoot.hide()
            }

            implicitWidth: dashRoot.screen.width * 0.5
            implicitHeight: implicitWidth * 0.6

            exclusiveZone: 0

            DashboardContent {
                anchors.fill: parent
                isBottom: root.bottom
            }
        }
    }

    IpcHandler {
        target: "dashboard"

        function toggle(): void {
            GlobalStates.dashboardOpened = !GlobalStates.dashboardOpened;
        }
    }

    GlobalShortcut {
        name: "toggleDashboard"
        description: "Toggle dashboard"
        onPressed: {
            GlobalStates.dashboardOpened = !GlobalStates.dashboardOpened;
        }
    }
}
