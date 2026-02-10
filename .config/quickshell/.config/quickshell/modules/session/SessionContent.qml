pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root

    color: Colors.alpha(Colors.palette.m3shadow, 0.4)

    property string currentActionLabel: ""
    property string currentActionDesc: ""

    readonly property var sessionModel: [
        {
            label: "Lock",
            desc: "Lock your screen",
            icon: "lock",
            action: Session.lock
        },
        {
            label: "Suspend",
            desc: "Suspend your device",
            icon: "bedtime",
            action: Session.suspend
        },
        {
            label: "Logout",
            desc: "Exit Hyprland",
            icon: "exit_to_app",
            action: Session.logout
        },
        {
            label: "Reboot",
            desc: "Reboot your device",
            icon: "refresh",
            action: Session.reboot
        },
        {
            label: "Poweroff",
            desc: "Turn off your device",
            icon: "power_settings_new",
            action: Session.poweroff
        }
    ]

    ScreencopyView {
        id: bg
        captureSource: root.QsWindow.window?.screen
        scale: 1.05
        anchors.fill: parent

        layer.enabled: true
        layer.effect: MultiEffect {
            source: bg
            blur: 1
            blurEnabled: true
            brightness: -0.05

            blurMax: 100
        }
    }

    ColumnLayout {
        id: content
        anchors.centerIn: parent
        spacing: Appearance.spacing.xl

        RowLayout {
            id: buttons

            KeyNavigation.tab: repeater.itemAt(0)

            Repeater {
                id: repeater
                model: root.sessionModel

                Component.onCompleted: {
                    if (repeater.count > 0) {
                        repeater.itemAt(0).forceActiveFocus();
                    }
                }

                delegate: IconButton {
                    id: btnDelegate
                    required property var modelData
                    required property int index

                    padding: Appearance.spacing.xl
                    iconSize: 48
                    icon: modelData.icon

                    activeFocusOnTab: true
                    checked: activeFocus

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            root.currentActionLabel = modelData.label;
                            root.currentActionDesc = modelData.desc;
                        }
                    }

                    KeyNavigation.right: (index < repeater.count - 1) ? repeater.itemAt(index + 1) : repeater.itemAt(0)
                    KeyNavigation.left: (index > 0) ? repeater.itemAt(index - 1) : repeater.itemAt(repeater.count - 1)

                    onClicked: modelData.action()

                    Keys.onEnterPressed: clicked()
                    Keys.onReturnPressed: clicked()
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Appearance.spacing.xs

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: root.currentActionLabel
                size: Appearance.fontSize.lg
                color: Colors.palette.m3onSurface
                weight: 500

                opacity: text === "" ? 0 : 1
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter

                text: root.currentActionDesc

                size: Appearance.fontSize.md
                color: Colors.palette.m3outline

                opacity: text === "" ? 0 : 1
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }
        }
    }
}
