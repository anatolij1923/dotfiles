import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.common
import qs.widgets

Rectangle {
    id: root
    property int padding: Appearance.padding.normal

    implicitHeight: content.implicitHeight + padding * 2
    implicitWidth: content.implicitWidth + padding * 2

    Layout.fillHeight: true
    Layout.fillWidth: true

    color: Colors.alpha(Colors.palette.m3surfaceContainer, 0.4)
    radius: Appearance.rounding.huge

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: root.padding
        spacing: Appearance.padding.large

        // Header with DND toggle only (no title)
        // Item {
        //     id: header
        //     Layout.fillWidth: true
        //     implicitHeight: 40

        //     RowLayout {
        //         anchors.fill: parent
        //         spacing: Appearance.padding.normal

        //         // Spacer to push DND button to the right
        //         Item {
        //             Layout.fillWidth: true
        //         }

        //         // DND Toggle button
        //         IconButton {
        //             icon: Notifications.dnd ? "notifications_off" : "notifications"
        //             checked: Notifications.dnd
        //             onClicked: Notifications.dnd = !Notifications.dnd
        //             horizontalPadding: Appearance.padding.larger
        //             verticalPadding: Appearance.padding.small

        //             StyledTooltip {
        //                 text: "Do not disturb"
        //             }
        //         }
        //     }
        // }

        // Separator line
        // Rectangle {
        //     Layout.fillWidth: true
        //     height: 1
        //     color: Qt.alpha(Colors.palette.m3onSurface, 0.05)
        //     visible: Notifications.list.length > 0
        // }

        // Empty state or notification list
        Item {
            id: notificationsContainer
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Show empty state when no notifications
            Item {
                id: noNotifs
                anchors.fill: parent
                visible: Notifications.list.length === 0

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Appearance.padding.large

                    MaterialSymbol {
                        icon: "notifications_paused"
                        size: 64
                        color: Qt.alpha(Colors.palette.m3onSurface, 0.2)
                        Layout.alignment: Qt.AlignHCenter
                    }

                    StyledText {
                        text: Translation.tr("quicksettings.notifications.everything_quiet")
                        size: 18
                        color: Qt.alpha(Colors.palette.m3onSurface, 0.4)
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Show notification list when notifications exist
            NotificationListView {
                id: persistentNotificationsView
                anchors.fill: parent
                model: Notifications.list
                visible: Notifications.list.length > 0
            }
        }
    }

    // Overlay "Clear all" button positioned at bottom right

    TextIconButton {
        id: clearAllButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Appearance.padding.normal

        text: Translation.tr("quicksettings.notifications.clear")
        icon: "delete_sweep"
        enabled: Notifications.list.length > 0

        onClicked: Notifications.clearAll()

        horizontalPadding: Appearance.padding.larger
        verticalPadding: Appearance.padding.small

        // Make it appear as an overlay with elevation
        // Elevation {
        //     anchors.fill: parent
        //     level: 3
        //     z: -1
        //     radius: parent.radius
        // }

        StyledTooltip {
            text: Translation.tr("quicksettings.notifications.clear_all")
        }
    }
}
