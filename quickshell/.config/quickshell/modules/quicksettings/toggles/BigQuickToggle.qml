import qs.modules.common
import qs.services
import qs
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property alias title: title.text
    property alias substring: substring.text
    property alias icon: button.icon
    property int padding: Appearance.padding.normal
    property alias checked: button.checked
    radius: Appearance.rounding.huge

    color: Colors.surface_container_high

    implicitWidth: content.implicitWidth + padding * 2
    implicitHeight: content.implicitHeight + padding * 2

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: root.padding
        spacing: Appearance.padding.normal
        IconButton {
            id: button
            padding: Appearance.padding.normal
            radius: checked ? Appearance.rounding.normal : Appearance.rounding.full
            checked: true
            iconSize: 32

            // Behavior on radius {
            //     Anim {
            //         duration: Appearance.animDuration.expressiveFastSpatial
            //         easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
            //     }
            // }
        }

        Column {
            id: text
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            StyledText {
                id: title
                weight: 500
            }
            StyledText {
                id: substring
                size: 15
            }
        }
    }
}
