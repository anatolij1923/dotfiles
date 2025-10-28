import qs.modules.common
import qs.services
import qs
import QtQuick
import QtQuick.Layouts

IconButton {
    id: root
    toggle: false
    Layout.preferredWidth: implicitWidth + (stateLayer.pressed ? Appearance.padding.huge : internalChecked ? Appearance.padding.smaller : 0)

    implicitHeight: 45
    implicitWidth: 45
    // enabled: true
    iconSize: 28

    Behavior on Layout.preferredWidth {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }
}

// StyledButton {
//     id: root

//     implicitHeight: 45
//     Layout.preferredWidth: implicitWidth + (toggled ? (pressed ? 24 : 16) : (pressed ? 16 : 0))
//     // implicitWidth: toggled ? (pressed ? 64 : 56) : (pressed ? 56 : 40)
//     implicitWidth: 45

//     buttonRadius: toggled ? (pressed ? 12 : 24) : (pressed ? 12 : 32)
//     buttonIconSize: 28

//     normalBg: Colors.surface_container
//     toggledBg: Colors.primary
//     toggledTextColor: Colors.surface

//     rippleEnabled: true
//     Behavior on Layout.preferredWidth {
//         Anim {
//             duration: Appearance.animDuration.expressiveFastSpatial
//             easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
//         }
//     }
// }
