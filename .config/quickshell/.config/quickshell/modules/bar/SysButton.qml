import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services
import qs

Rectangle {
    id: root

    property int padding: Appearance.padding.small
    property bool quicksettingsOpened

    Connections {
        target: GlobalStates
        function onQuicksettingsOpenedChanged() {
            root.quicksettingsOpened = !root.quicksettingsOpened;
        }
    }

    implicitWidth: content.implicitWidth + Appearance.padding.small * 2
    implicitHeight: parent.height * 0.8
    color: root.quicksettingsOpened ? Colors.palette.m3secondaryContainer : "transparent"
    radius: Appearance.rounding.huge

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.expressiveEffects
            easing.bezierCurve: Appearance.animCurves.emphasized
        }
    }

    clip: true

    Behavior on color {
        CAnim {}
    }

    StateLayer {
        anchors.fill: parent

        onClicked: () => {
            GlobalStates.quicksettingsOpened = true;
        }
    }

    RowLayout {
        id: content
        anchors.centerIn: parent

        spacing: root.padding

        KbLayout {}

        Loader {
            active: SleepTimer.enabled

            visible: active
            sourceComponent: SleepTimerWidget {}
        }

        Loader {
            active: Notifications.dnd || Notifications.list.length > 0

            visible: active
            sourceComponent: NotifWidget {
                opacity: parent.visible
                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
            }
        }

        NetworkWidget {}

        Loader {
            active: BluetoothService.enabled
            visible: active
            sourceComponent: BluetoothWidget {}
        }

        Loader {
            active: Audio.source?.audio?.muted
            visible: active
            sourceComponent: MicWidget {
                opacity: parent.visible
                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
            }
        }
    }
}
