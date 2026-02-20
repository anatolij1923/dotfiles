import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

Rectangle {
    id: root
    // visible: Record.isRecording || scale > 0
    visible: true
    

    implicitWidth: visible ? (content.implicitWidth + Appearance.spacing.md * 2) : 0
    implicitHeight: content.implicitHeight + Appearance.spacing.xs * 2

    scale: Record.isRecording ? 1 : 0

    // color: Qt.alpha(Colors.palette.m3errorContainer, 0.3)
    color: Colors.palette.m3errorContainer

    radius: Appearance.rounding.full

    Behavior on scale {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    StateLayer {
        anchors.fill: parent
        onClicked: Record.toggle()
    }

    RowLayout {
        id: content
        anchors.centerIn: parent

        MaterialSymbol {
            id: icon
            icon: "screen_record"
            color: Colors.palette.m3onErrorContainer
        }
        StyledText {
            text: Record.duration
            color: Colors.palette.m3onErrorContainer
            size: Appearance.fontSize.md
            weight: 450
        }
    }
}
