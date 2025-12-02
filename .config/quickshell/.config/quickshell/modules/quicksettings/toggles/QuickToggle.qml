import qs.modules.common
import qs.services
import qs
import QtQuick
import QtQuick.Layouts

IconButton {
    id: root
    property string tooltipText: ""
    toggle: false
    Layout.preferredWidth: implicitWidth + (stateLayer.pressed ? Appearance.padding.huge : internalChecked ? Appearance.padding.smaller : 0)
    Layout.fillWidth: true

    implicitHeight: 55
    // enabled: true
    iconSize: 28

    Behavior on Layout.preferredWidth {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    StyledTooltip {
        text: root.tooltipText
        verticalPadding: Appearance.padding.normal
        horizontalPadding: Appearance.padding.normal
    }
}
