import qs.common
import qs.widgets
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

    radius: checked ? Appearance.rounding.huge : Appearance.rounding.full

    Behavior on radius {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    color: Colors.palette.m3surfaceContainer

    implicitWidth: content.implicitWidth + padding * 2
    implicitHeight: content.implicitHeight + padding * 2

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    StateLayer {
        anchors.fill: parent
    }

    Elevation {
        anchors.fill: parent
        level: 3
        z: -1
        radius: parent.radius
        opacity: 0.5
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
            // radius: checked ? Appearance.rounding.normal : 50
            radius: checked ? (stateLayer.pressed ? Appearance.rounding.small : Appearance.rounding.normal) : (stateLayer.pressed ? Appearance.rounding.huge : Appearance.rounding.full)

            Behavior on radius {
                Anim {
                    duration: Appearance.animDuration.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                }
            }

            checked: true
            iconSize: 32

            inactiveColor: Colors.palette.m3surfaceContainerHigh
            activeColor: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.8)

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
                visible: root.substring !== ""
                size: Appearance.font.size.small
                animate: true
                width: 115
                elide: Text.ElideRight
            }
        }
    }
}
