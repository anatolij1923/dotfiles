import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common

Rectangle {
    id: root
    visible: Record.isRecording || scale > 0

    property int padding: Appearance.padding.smaller
    implicitWidth: visible ? (content.implicitWidth + padding * 2) : 0
    implicitHeight: content.implicitHeight + padding * 2

    scale: Record.isRecording ? 1 : 0

    color: Qt.alpha(Colors.palette.m3errorContainer, 0.3)

    radius: Appearance.rounding.normal

    Behavior on scale {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    StateLayer {
        anchors.fill: parent
        onClicked: Record.stop()
    }

    RowLayout {
        id: content
        anchors.centerIn: parent

        MaterialSymbol {
            id: icon
            icon: "screen_record"
            color: Colors.palette.m3error
        }
        StyledText {
            text: Record.duration
            color: Colors.palette.m3error
            weight: 600
        }
    }
}
