import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.widgets
import qs.services

Scope {
    id: root

    Loader {
        active: PolkitService.active
        sourceComponent: StyledWindow {
            id: polkitRoot
            name: "polkit"

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore

            HyprlandFocusGrab {
                windows: [polkitRoot]
                active: PolkitService.active
                onCleared: {
                    if (!active) {
                        PolkitService.cancel();
                    }
                }
            }
            implicitWidth: 650
            implicitHeight: 270

            Loader {
                active: true
                anchors.fill: parent
                focus: true
                sourceComponent: PolkitContent {}
            }
        }
    }
}
