pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.common
import qs.widgets
import qs.services

Scope {
    id: root

    Loader {
        active: GlobalStates.sessionOpened

        sourceComponent: StyledWindow {
            id: sessionRoot

            name: "session"

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            function hide() {
                GlobalStates.sessionOpened = false;
            }

            HyprlandFocusGrab {
                windows: [sessionRoot]
                active: GlobalStates.sessionOpened
                onCleared: if (!active) {
                    sessionRoot.hide();
                }
            }

            SessionContent {
                id: content
                anchors.fill: parent
                // focus: true
                Keys.onEscapePressed: sessionRoot.hide()
                Component.onCompleted: {
                    content.forceActiveFocus();
                }
            }
        }
    }

    IpcHandler {
        target: "session"

        function toggle(): void {
            GlobalStates.sessionOpened = !GlobalStates.sessionOpened;
        }
    }

    GlobalShortcut {
        name: "toggleSession"
        description: "Open session window"

        onPressed: {
            GlobalStates.sessionOpened = !GlobalStates.sessionOpened;
        }
    }
}
