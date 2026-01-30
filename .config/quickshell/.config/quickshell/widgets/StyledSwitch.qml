import QtQuick
import qs.services
import QtQuick.Controls
import qs.common
import qs.widgets

Switch {
    id: root

    implicitWidth: implicitIndicatorWidth
    implicitHeight: implicitIndicatorHeight

    property color activeColor: Colors.palette.m3primary
    property color inactiveColor: Colors.palette.m3surfaceContainerHighest

    indicator: Rectangle {
        id: track
        radius: Appearance.rounding.full
        implicitWidth: implicitHeight * 1.7
        implicitHeight: 20 + Appearance.padding.small * 2

        border {
            width: root.checked ? 0 : 2
            color: Colors.palette.m3outline
        }

        color: root.checked ? root.activeColor : root.inactiveColor

        Behavior on color {
            CAnim {}
        }

        Rectangle {
            id: handle
            property real margin: Appearance.padding.smaller
            width: parent.height - margin * 2
            height: width
            radius: width / 2
            color: root.checked ? Colors.palette.m3onPrimary : Colors.palette.m3outline

            anchors.verticalCenter: parent.verticalCenter

            x: root.checked ? (parent.width - width - margin) : margin

            Behavior on x {
                Anim {}
            }

            Behavior on color {
                CAnim {}
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: false
    }
}
