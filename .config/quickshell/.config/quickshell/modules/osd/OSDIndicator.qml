import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

Item {
    id: root

    property bool scaleIcon: false
    property bool rotateIcon: false
    property real value
    property string icon
    property int padding: Appearance.padding.large

    implicitWidth: Appearance.sizes.osdWidth + padding * 2
    implicitHeight: content.implicitHeight + padding * 2

    Rectangle {
        color: Colors.surface_container
        anchors.fill: parent
        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight * 2
        radius: Appearance.rounding.huge
        border {
            width: 1
            color: Colors.surface_container_highest
        }

        RowLayout {
            id: content
            anchors.fill: parent
            spacing: 12

            MaterialSymbol {
                icon: root.icon
                size: 32
                rotation: 180 * (root.rotateIcon ? value : 0)
                color: Colors.on_surface
                Layout.leftMargin: root.padding

                Behavior on size {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
                Behavior on rotation {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
            }
            StyledSlider {
                configuration: StyledSlider.Configuration.XS
                value: root.value
                handleHeight: 25
            }

            StyledText {
                text: Math.round(root.value * 100)
                Layout.rightMargin: root.padding
            }
        }
    }
}
