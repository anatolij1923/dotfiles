import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.modules.common
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
    radius: Appearance.rounding.huge

    Layout.fillWidth: true

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: root.padding
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

    component QuickSlider: StyledSlider {
        id: root

        property alias icon: iconItem.icon
        property color iconColor: value > 0.08 ? Colors.palette.m3surface : Colors.palette.m3onSurface
        property var onMovedHandler

        stopIndicatorValues: []
        configuration: StyledSlider.Configuration.M

        onMoved: {
            if (typeof root.onMovedHandler === "function") {
                root.onMovedHandler(value);
            }
        }

        MaterialSymbol {
            id: iconItem
            color: root.iconColor

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            anchors.leftMargin: Appearance.padding.normal
        }
    }
}
