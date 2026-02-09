import QtQuick
import QtQuick.Layouts
import qs
import qs.config
import qs.services
import qs.common
import qs.widgets

Item {
    id: root

    property bool scaleIcon: false
    property bool rotateIcon: false
    property real value
    property string icon
    property int padding: Appearance.padding.large

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    implicitWidth: Appearance.sizes.osdWidth + padding * 2
    implicitHeight: content.implicitHeight + padding * 2

    Rectangle {
        color: root.transparent ? Qt.alpha(Colors.palette.m3surfaceContainer, root.alpha) : Colors.palette.m3surfaceContainer
        anchors.fill: parent
        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight * 2
        radius: Appearance.rounding.xl
        border {
            width: 1
            color: Colors.palette.m3surfaceContainerHighest
        }

        RowLayout {
            id: content
            anchors.fill: parent
            spacing: 12

            MaterialSymbol {
                icon: root.icon
                size: 32
                rotation: 180 * (root.rotateIcon ? value : 0)
                color: Colors.palette.m3onSurface
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
