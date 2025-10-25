import QtQuick
import qs.services
import Quickshell
import qs.modules.notifications

ListView {
    id: listView

    implicitHeight: contentHeight

    spacing: 8

    model: ScriptModel {
        values: Notifications.list.filter(n => n.popup)
    }

    delegate: NotificationChild {
        required property Notifications.Notif modelData
        appIcon: modelData.appIcon
        appName: modelData.appName || "Unknown"
        time: modelData.timeStr
        title: modelData.summary
        body: modelData.body
        image: modelData.image || modelData.appIcon
        rawNotif: modelData

        buttons: modelData.actions.map(action => ({
                    label: action.text,
                    onClick: () => action.invoke()
                }))
    }
}
