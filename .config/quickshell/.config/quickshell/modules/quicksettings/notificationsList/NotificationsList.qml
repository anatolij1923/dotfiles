import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common

Item {
    id: notificationList
    Layout.fillHeight: true
    Layout.fillWidth: true

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 12
        RowLayout {
            id: notificationListHeader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: clearButton.implicitHeight
                color: Qt.alpha(Colors.palette.m3surfaceContainer, 0.4)
                radius: Appearance.rounding.normal

                StyledText {
                    id: counter
                    anchors.centerIn: parent
                    text: `${Notifications.list.length} Notifications`
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            TextButton {
                id: clearButton
                text: "Clear"
                onClicked: Notifications.clearAll()
                padding: Appearance.padding.normal
                inactiveColor: Qt.alpha(Colors.palette.m3surfaceContainer, 0.6)
            }
        }

        NotificationListView {
            id: persistentNotificationsView
            model: Notifications.list
            implicitWidth: parent.width
            implicitHeight: notificationList.height
        }
    }
}
