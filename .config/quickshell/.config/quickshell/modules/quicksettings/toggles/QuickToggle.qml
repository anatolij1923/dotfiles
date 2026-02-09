import qs.common
import qs.widgets
import qs.services
import qs
import QtQuick
import QtQuick.Layouts

IconButton {
    id: root
    property string tooltipText: ""
    toggle: false
    Layout.preferredWidth: implicitWidth + (stateLayer.pressed ? Appearance.spacing.lg : internalChecked ? Appearance.spacing.sm : 0)
    Layout.fillWidth: true

    activeColor: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.8)

    iconSize: 32

    padding: Appearance.spacing.md

    Behavior on Layout.preferredWidth {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    StyledTooltip {
        text: root.tooltipText
    }

    Elevation {
        anchors.fill: parent
        level: 3
        radius: parent.radius
        opacity: 0.5
        z: -1
    }
}
