pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import qs
import qs.services
import qs.common
import qs.widgets

Scope {
    Loader {
        active: GlobalStates.mediaplayerOpened
        sourceComponent: StyledWindow {
            id: root
            name: "mediaplayer"

            implicitWidth: 400
            implicitHeight: 650

            anchors {
                top: true
            }

            margins {
                top: Appearance.spacing.md
            }

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            exclusiveZone: 0

            function hide() {
                GlobalStates.mediaplayerOpened = false;
            }

            HyprlandFocusGrab {
                windows: [root]
                active: GlobalStates.mediaplayerOpened
                onCleared: if (!active)
                    root.hide()
            }

            MediaplayerContent {
                anchors {
                    fill: parent
                }
            }
        }
    }

    GlobalShortcut {
        name: "toggleMediaplayer"
        onPressed: {
            GlobalStates.mediaplayerOpened = !GlobalStates.mediaplayerOpened;
        }
    }
}
