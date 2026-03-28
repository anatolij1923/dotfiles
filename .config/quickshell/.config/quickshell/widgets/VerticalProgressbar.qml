pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import qs.common

ClippingRectangle {
    id: root

    required property real value

    implicitHeight: parent.height
    implicitWidth: 6

    radius: Appearance.rounding.full
    color: Colors.alpha(Colors.palette.m3outline, 0.35)

    Rectangle {
        id: fill
        color: Colors.palette.m3secondary
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        implicitHeight: parent.height * root.value
        Behavior on implicitHeight {
            Anim {
                duration: Appearance.animDuration.expressiveEffects
                easing.bezierCurve: Appearance.animCurves.expressiveEffects
            }
        }
    }
}
