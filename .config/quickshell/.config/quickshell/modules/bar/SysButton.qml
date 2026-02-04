import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services
import qs

Rectangle {
    id: root

    property int padding: Appearance.padding.small
    property bool quicksettingsOpened: GlobalStates.quicksettingsOpened

    implicitWidth: content.implicitWidth + Appearance.padding.small * 2
    implicitHeight: parent.height * 0.8
    color: quicksettingsOpened ? Colors.palette.m3secondaryContainer : "transparent"
    radius: Appearance.rounding.huge

    // Главная ширина плашки: используем Decel для быстрого, но мягкого торможения
    // Behavior on implicitWidth {
    //     Anim {
    //         duration: Appearance.animDuration.small // 200ms - золотой стандарт
    //         easing.bezierCurve: Appearance.animCurves.emphasizedDecel
    //     }
    // }

    Behavior on color {
        CAnim {}
    }

    clip: true

    StateLayer {
        anchors.fill: parent
        onClicked: GlobalStates.quicksettingsOpened = true
    }

    RowLayout {
        id: content
        anchors.centerIn: parent
        // Важно: если иконки исчезают, spacing может давать микро-прыжок.
        // Но с Decel-кривой это будет почти незаметно.
        spacing: root.padding

        KbLayout {}

        AnimatedItem {
            condition: Idle.enabled
            contentItem: IdleWidget {}
        }

        AnimatedItem {
            condition: SleepTimer.enabled
            contentItem: SleepTimerWidget {}
        }

        AnimatedItem {
            condition: Notifications.dnd || Notifications.list.length > 0
            contentItem: NotifWidget {}
        }

        AnimatedItem {
            condition: Audio.source?.audio?.muted
            contentItem: MicWidget {}
        }

        NetworkWidget {}

        AnimatedItem {
            condition: BluetoothService.enabled
            contentItem: BluetoothWidget {}
        }
    }

    component AnimatedItem: Item {
        property bool condition: false
        property Component contentItem: null

        Layout.preferredWidth: condition ? loader.implicitWidth : 0
        Layout.fillHeight: true

        opacity: condition ? 1.0 : 0.0
        scale: condition ? 1.0 : 0.8
        visible: opacity > 0

        Behavior on Layout.preferredWidth {
            Anim {
                duration: Appearance.animDuration.expressiveEffects
                easing.bezierCurve: Appearance.animCurves.expressiveEffects
            }
        }

        Behavior on opacity {
            Anim {
                duration: Appearance.animDuration.expressiveEffects
                easing.bezierCurve: Appearance.animCurves.expressiveEffects
            }
        }

        Behavior on scale {
            Anim {
                duration: Appearance.animDuration.expressiveEffects
                easing.bezierCurve: Appearance.animCurves.expressiveEffects
            }
        }

        Loader {
            id: loader
            anchors.centerIn: parent
            active: parent.condition || parent.opacity > 0
            sourceComponent: parent.contentItem
        }
    }
}
