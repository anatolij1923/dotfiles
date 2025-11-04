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
    property alias checked: button.checked
    property alias toggle: button.toggle
    property alias enabled: button.enabled
    property int padding: Appearance.padding.normal
    property string tooltipText: ""

    signal clicked
    signal rightClicked
    signal middleClicked

    radius: Appearance.rounding.huge

    color: Colors.surface_container

    implicitWidth: content.implicitWidth + padding * 2
    implicitHeight: content.implicitHeight + padding * 2

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: root.padding
        spacing: Appearance.padding.normal
        IconButton {
            id: button
            padding: Appearance.padding.normal
            // radius: checked ? Appearance.rounding.normal : Appearance.rounding.full
            radius: checked ? (stateLayer.pressed ? Appearance.rounding.small : Appearance.rounding.normal) : (stateLayer.pressed ? Appearance.rounding.small : Appearance.rounding.huge)

            Behavior on radius {
                Anim {
                    duration: Appearance.animDuration.expressiveFastSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                }
            }
            checked: true
            iconSize: 32

            inactiveColor: Colors.surface_container_high

            onClicked: root.clicked()
            onRightClicked: root.rightClicked()
            onMiddleClicked: root.middleClicked()

            // Behavior on radius {
            //     Anim {
            //         duration: Appearance.animDuration.expressiveFastSpatial
            //         easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
            //     }
            // }
            //
            StyledTooltip {
                text: root.tooltipText
                verticalPadding: 8
                horizontalPadding: 12
            }
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
                animate: true
            }
        }
    }
}
