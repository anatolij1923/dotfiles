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

