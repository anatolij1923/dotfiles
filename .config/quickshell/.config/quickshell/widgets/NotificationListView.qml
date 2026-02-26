import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import Quickshell
import qs.modules.notifications

ListView {
    id: listView

    implicitHeight: contentHeight

    interactive: contentHeight > height
    flickableDirection: Flickable.VerticalFlick

    spacing: 8
    ScrollBar.vertical: ScrollBar {}
    clip: true

    model: ScriptModel {
        values: Notifications.list.filter(n => n.popup)
    }
    delegate: NotificationChild {
        // required property Notifications.Notif modelData
        width: listView.width

        Layout.fillWidth: true

        // appIcon: modelData.appIcon
        // appName: modelData.appName || "Unknown"
        // time: modelData.timeStr
        // summary: modelData.summary
        // body: modelData.body
        // image: modelData.image || modelData.appIcon
        // rawNotif: modelData
        //
        // buttons: modelData.actions.map(action => ({
        //             label: action.text,
        //             onClick: () => action.invoke()
        //         }))
    }
}
