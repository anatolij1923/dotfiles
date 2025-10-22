import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland // Возможно, понадобится для позиционирования

// Импортируем наш синглтон уведомлений
import qs.services // Предполагается, что Notifications.qml находится в этом пути или доступен глобально

Scope {
    id: root
    property int innerSpacing: 10

    PanelWindow {
        id: window
        implicitWidth: 400
        visible: true
        anchors {
            top: true
            bottom: true
            right: true
        }
        color: "transparent"

        // Упрощенная логика Wayland, если нужна
        WlrLayershell.layer: WlrLayer.Overlay
        // WlrLayershell.exclusionMode: ExclusionMode.Normal
        exclusiveZone: 0

        mask: Region {
            width: window.width
            height: {
                var total = 0;
                for (let i = 0; i < rep.count; i++) {
                    var child = rep.itemAt(i);
                    if (child) {
                        total += child.height + (i < rep.count - 1 ? root.innerSpacing : 0);
                    }
                }
                return total;
            }
        }

        Item {
            id: notificationList
            // anchors.leftMargin: 20
            // anchors.topMargin: 10
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            Rectangle {
                id: bgRectangle
                // Упрощенные эффекты и цвета
                // anchors.top: parent.top
                // anchors.left: parent.left
                // anchors.leftMargin: 20
                // anchors.rightMargin: 0
                // anchors.right: parent.right
                anchors.fill: parent
                height: window.mask.height > 0 ? window.mask.height + 40 : 0
                color: "white" // Временный цвет
                Behavior on height {
                    NumberAnimation {
                        duration: 200 // Временная длительность анимации
                        easing.type: Easing.OutExpo
                    }
                }
            }

            Repeater {
                id: rep
                // Подключаем наш синглтон Notifications
                model: Notifications.list.filter(n => n.popup)

                delegate: NotificationChild { // Этот компонент будет создан позже
                    id: child
                    width: bgRectangle.width - 40
                    x: 20
                    //
                    y: {
                        var pos = 0;
                        for (let i = 0; i < index; i++) {
                            var prev = rep.itemAt(i);
                            if (prev)
                                pos += prev.height + root.innerSpacing;
                        }
                        return pos + 20; // Упрощено
                    }

                    Behavior on y {
                        NumberAnimation {
                            duration: 200 // Временная длительность анимации
                            easing.type: Easing.OutExpo
                        }
                    }

                    title: modelData.summary
                    body: modelData.body
                    image: modelData.image || modelData.appIcon
                    rawNotif: modelData
                    // tracked: modelData.shown // Удалено, если не нужно
                    buttons: modelData.actions.map(action => ({
                                label: action.text,
                                onClick: () => {
                                    action.invoke();
                                }
                            }))
                }
            }
        }
    }
}
