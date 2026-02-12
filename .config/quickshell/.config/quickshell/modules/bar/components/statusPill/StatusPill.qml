pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services
import qs
import qs.modules.bar.components.statusPill.components

Rectangle {
    id: root

    property int padding: Appearance.spacing.sm
    property bool quicksettingsOpened: GlobalStates.quicksettingsOpened

    implicitWidth: content.implicitWidth + root.padding
    implicitHeight: parent.height * 0.8
    color: quicksettingsOpened ? Colors.palette.m3secondaryContainer : Colors.palette.m3surface
    radius: Appearance.rounding.xl

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
        anchors.left: parent.left
        anchors.leftMargin: root.padding
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        AnimatedItem {
            condition: true
            contentItem: KbLayout {}
        }

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
            condition: Audio.sink?.audio?.muted || false
            contentItem: AudioMutedWidget {}
        }

        AnimatedItem {
            condition: Audio.source?.audio?.muted || false
            contentItem: MicWidget {}
        }

        AnimatedItem {
            condition: true
            contentItem: NetworkWidget {}
        }

        AnimatedItem {
            condition: BluetoothService.enabled
            contentItem: BluetoothWidget {}
        }
    }

    component AnimatedItem: Item {
        id: itemRoot
        property bool condition: false
        property Component contentItem: null

        readonly property real contentWidth: loader.item ? loader.item.implicitWidth : 22

        implicitWidth: condition ? (contentWidth + root.padding) : 0
        Layout.preferredWidth: implicitWidth
        Layout.fillHeight: true

        opacity: condition ? 1.0 : 0.0
        scale: condition ? 1.0 : 0.1

        visible: opacity > 0

        Behavior on implicitWidth {
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
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            active: itemRoot.condition || itemRoot.opacity > 0
            sourceComponent: itemRoot.contentItem
        }
    }
}
