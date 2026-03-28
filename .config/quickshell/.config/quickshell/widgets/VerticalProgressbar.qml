pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Widgets
import qs.services
import qs.common

ClippingRectangle {
    id: root

    required property real value
    property string fillColor: Colors.palette.m3secondary

    implicitHeight: parent.height
    implicitWidth: 6

    radius: Appearance.rounding.full
    color: Colors.alpha(Colors.palette.m3outline, 0.35)

    Rectangle {
        id: fill
        color: root.fillColor
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
