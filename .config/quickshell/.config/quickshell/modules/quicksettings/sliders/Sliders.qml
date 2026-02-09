import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services
import qs

Rectangle {
    id: root

    property int padding: Appearance.padding.normal
    property var screen: root.QsWindow.window?.screen
    property var brightnessMonitor: Brightness.getMonitorForScreen(screen)

    implicitHeight: content.implicitHeight + padding * 2
    implicitWidth: content.implicitWidth + padding * 2
    color: Qt.alpha(Colors.palette.m3surfaceContainer, 0.4)
    radius: Appearance.rounding.xl

    Layout.fillWidth: true

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: root.padding

        QuickSlider {
            icon: "volume_up"
            value: Audio.sink.audio.volume
            onMovedHandler: v => Audio.sink.audio.volume = v
        }
        QuickSlider {
            icon: "brightness_6"
            value: root.brightnessMonitor ? root.brightnessMonitor.brightness : 0
            onMovedHandler: v => {
                if (root.brightnessMonitor) {
                    root.brightnessMonitor.setBrightness(v);
                }
            }
        }
    }

    component QuickSlider: StyledSlider {
        id: sliderInstance

        property alias icon: iconItem.icon
        readonly property bool iconShouldJump: visualPosition > 0.9

        property color iconColor: iconShouldJump ? Colors.palette.m3onPrimary : Colors.palette.m3onSurfaceVariant

        property var onMovedHandler

        stopIndicatorValues: []
        configuration: StyledSlider.Configuration.M

        onMoved: {
            if (typeof sliderInstance.onMovedHandler === "function") {
                sliderInstance.onMovedHandler(value);
            }
        }

        MaterialSymbol {
            id: iconItem
            color: sliderInstance.iconColor

            anchors.verticalCenter: parent.verticalCenter

            x: sliderInstance.iconShouldJump ? (sliderInstance.handle.x - width - Appearance.padding.small) : (parent.width - width - Appearance.padding.normal)

            Behavior on x {
                Anim {
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    duration: Appearance.animDuration.expressiveFastSpatial
                }
            }

            Behavior on color {
                CAnim {}
            }
        }
    }
}
