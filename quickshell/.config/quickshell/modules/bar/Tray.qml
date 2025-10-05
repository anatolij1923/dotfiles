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

            delegate: Rectangle {
                id: trayItem
                color: "transparent"
                width: 25
                height: 25
                radius: 4

                IconImage {
                    width: 18
                    height: 18
                    anchors.centerIn: parent
                    source: modelData.icon
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: trayItem.color = Colors.secondary
                    onExited: trayItem.color = "transparent"
                }


                Behavior on color {
                    ColorAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
