pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property list<Notif> list: []

    NotificationServer {
        id: server

        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notif => {
            notif.tracked = true;

            const comp = notifComp.createObject(root, {
                popup: true // Упрощено, всегда показывать как popup
                ,
                notification: notif
            });
            root.list = [comp, ...root.list];
        }
    }

    component Notif: QtObject {
        id: notif

        property bool popup: true
        property bool closed: false
        property var locks: new Set()

        property date time: new Date()
        readonly property string timeStr: {
            const diff = Time.date.getTime() - time.getTime();
            const m = Math.floor(diff / 60000);

            if (m < 1)
                return qsTr("now");

            const h = Math.floor(m / 60);
            const d = Math.floor(h / 24);

            if (d > 0)
                return `${d}d`;
            if (h > 0)
                return `${h}h`;
            return `${m}m`;
        }

        property Notification notification
        property string id
        property string summary
        property string body
        property string appIcon
        property string appName
        property string image
        property real expireTimeout: 5000 // Упрощено, жестко задано 5 секунд
        property int urgency: NotificationUrgency.Normal
        property bool resident
        property bool hasActionIcons
        property list<var> actions

        readonly property Timer timer: Timer {
            running: true
            interval: notif.expireTimeout > 0 ? notif.expireTimeout : 5000
            onTriggered: {
                notif.popup = false; // Просто закрываем popup
            }
        }

        readonly property Connections conn: Connections {
            target: notif.notification

            function onClosed(): void {
                notif.close();
            }

            function onSummaryChanged(): void {
                notif.summary = notif.notification.summary;
            }

            function onBodyChanged(): void {
                notif.body = notif.notification.body;
            }

            function onAppIconChanged(): void {
                notif.appIcon = notif.notification.appIcon;
            }

            function onAppNameChanged(): void {
                notif.appName = notif.notification.appName;
            }

            function onImageChanged(): void {
                notif.image = notif.notification.image;
            }

            function onExpireTimeoutChanged(): void {
                notif.expireTimeout = notif.notification.expireTimeout;
            }

            function onUrgencyChanged(): void {
                notif.urgency = notif.notification.urgency;
            }

            function onResidentChanged(): void {
                notif.resident = notif.notification.resident;
            }

            function onHasActionIconsChanged(): void {
                notif.hasActionIcons = notif.notification.hasActionIcons;
            }

            function onActionsChanged(): void {
                notif.actions = notif.notification.actions.map(a => ({
                            identifier: a.identifier,
                            text: a.text,
                            invoke: () => a.invoke()
                        }));
            }
        }

        function lock(item: Item): void {
            locks.add(item);
        }

        function unlock(item: Item): void {
            locks.delete(item);
            if (closed)
                close();
        }

        function close(): void {
            closed = true;
            if (locks.size === 0 && root.list.includes(this)) {
                root.list = root.list.filter(n => n !== this);
                notification?.dismiss();
                destroy();
            }
        }

        Component.onCompleted: {
            if (!notification)
                return;

            id = notification.id;
            summary = notification.summary;
            body = notification.body;
            appIcon = notification.appIcon;
            appName = notification.appName;
            image = notification.image;
            expireTimeout = notification.expireTimeout;
            urgency = notification.urgency;
            resident = notification.resident;
            hasActionIcons = notification.hasActionIcons;
            actions = notification.actions.map(a => ({
                        identifier: a.identifier,
                        text: a.text,
                        invoke: () => a.invoke()
                    }));
        }
    }

    Component {
        id: notifComp

        Notif {}
    }
}
