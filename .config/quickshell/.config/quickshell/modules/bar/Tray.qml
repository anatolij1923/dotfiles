import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import qs
import qs.modules.common

Item {
    id: root
    implicitWidth: tray.implicitWidth
    implicitHeight: tray.implicitHeight

    RowLayout {
        id: tray
        spacing: 8
        Repeater {
            model: SystemTray.items

            delegate: TrayItem {}
        }
    }
}
