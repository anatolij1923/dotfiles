import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import qs
import qs.services
import qs.common
import qs.widgets

Loader {
    active: Notifications.dnd ? 0 : 1

    sourceComponent: StyledWindow {
        id: root
        name: "notifications"
        implicitHeight: listView.contentHeight
        implicitWidth: 450

        exclusiveZone: 0

        anchors {
            top: true
            right: true
            bottom: true
        }

        margins {
            top: Appearance.spacing.md
            right: Appearance.spacing.md
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
