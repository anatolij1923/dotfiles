import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs

Rectangle {
    id: root

    property var screen: root.QsWindow.window?.screen
    property var brightnessMonitor: Brightness.getMonitorForScreen(screen)

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth
    color: "transparent"
    Layout.fillWidth: true

    ColumnLayout {
        id: content
        anchors.fill: parent
        Loader {
            anchors {
                left: parent.left
                right: parent.right
            }
            active: true

            sourceComponent: QuickSlider {
                icon: "volume_up"
                value: Audio.sink.audio.volume
                onMovedHandler: v => Audio.sink.audio.volume = v
            }
        }

        Loader {
            anchors {
                left: parent.left
                right: parent.right
            }
            active: true

            sourceComponent: QuickSlider {
                icon: "brightness_6"
                value: root.brightnessMonitor.brightness
                onMovedHandler: v => root.brightnessMonitor.setBrightness(v)
            }
        }
    }

    component QuickSlider: RowLayout {
        id: root
        property alias icon: icon.icon
        property alias value: slider.value
        property color iconColor: Colors.on_surface
        property var onMovedHandler
        spacing: 16

        MaterialSymbol {
            id: icon
            color: root.iconColor
        }

        StyledSlider {
            id: slider
            stopIndicatorValues: []
            configuration: StyledSlider.Configuration.M

            onMoved: {
                if (typeof root.onMovedHandler === "function")
                    root.onMovedHandler(value);
            }
        }
    }
}
