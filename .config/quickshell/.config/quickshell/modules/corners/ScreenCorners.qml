import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.corners
import qs.widgets
import qs.config
import qs.common

Scope {
    id: root

    Loader {
        active: !Config.bar.floating

        sourceComponent: StyledWindow {
            id: cornersRoot
            name: "corners"
            property real alpha: Config.appearance.transparency.alpha
            property bool transparent: Config.appearance.transparency.enabled

            color: "transparent"
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            exclusionMode: ExclusionMode.Auto
            WlrLayershell.layer: WlrLayer.Top
            mask: Region {}

            Corners {
                corners: Config.bar.bottom ? [2, 3] : [0, 1]
                cornerHeight: 24
                cornerType: "inverted"
                color: cornersRoot.transparent ? Qt.alpha(Colors.palette.m3surface, cornersRoot.alpha) : Colors.palette.m3surface
                Behavior on color {
                    CAnim {}
                }
            }
        }
    }
}
