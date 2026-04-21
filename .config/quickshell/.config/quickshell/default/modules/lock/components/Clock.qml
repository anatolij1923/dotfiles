pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.config
import qs.modules.lock
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    ColumnLayout {
        id: content

        StyledText {
            id: time
            text: Time.format(Config.time.format)
            size: 128
            weight: 500
            color: Colors.isDarkMode ? Colors.palette.m3onSurface : Colors.palette.m3surface
            opacity: 0.8
        }

        StyledText {
            Layout.alignment: Qt.AlignCenter
            text: Time.format("dddd dd MMMM")
            size: Appearance.fontSize.lg
            weight: 450
            color: Colors.isDarkMode ? Colors.palette.m3onSurface : Colors.palette.m3surface
            opacity: 0.5
        }
    }
}
