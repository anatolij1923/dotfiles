import qs.services
import QtQuick
import Quickshell

OSDIndicator {
    id: root
    property var screen: root.QsWindow.window?.screen
    property var brightnessMonitor: Brightness.getMonitorForScreen(screen)

    rotateIcon: true

    value: root.brightnessMonitor?.brightness
    icon: "sunny"
}
