import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import qs
import qs.services
import qs.common
import qs.widgets

Scope {
    Loader {
        active: Notifications.dnd ? 0 : 1

        sourceComponent: PanelWindow {
            id: root
            WlrLayershell.layer: WlrLayer.Overlay
            implicitHeight: listView.contentHeight
            implicitWidth: 450

            exclusiveZone: 0

            anchors {
                top: true
                right: true
                bottom: true
            }
            margins {
                top: 16
                right: 16
            }

            color: "transparent"

            mask: Region {
                item: listView.contentItem
            }

            NotificationListView {
                id: listView
                implicitWidth: parent.width
                model: Notifications.popupList
                visible: GlobalStates.quicksettingsOpened ? 0 : 1
            }
        }
    }
}
