pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.common
import qs.config
import qs.widgets
import qs.services
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property string currentActionLabel: ""
    property string currentActionDesc: ""

    readonly property var sessionModel: [
        {
            label: Translation.tr("session.lock"),
            desc: Translation.tr("session.desc.lock"),
            icon: "lock",
            action: Session.lock
        },
        {
            label: Translation.tr("session.suspend"),
            desc: Translation.tr("session.desc.suspend"),
            icon: "bedtime",
            action: Session.suspend
        },
        {
            label: Translation.tr("session.logout"),
            desc: Translation.tr("session.desc.logout"),
            icon: "exit_to_app",
            action: Session.logout
        },
        {
            label: Translation.tr("session.reboot"),
            desc: Translation.tr("session.desc.reboot"),
            icon: "refresh",
            action: Session.reboot
        },
        {
            label: Translation.tr("session.shutdown"),
            desc: Translation.tr("session.desc.shutdown"),
            icon: "power_settings_new",
            action: Session.poweroff
        }
    ]

    ScreencopyView {
        id: bg
        captureSource: root.QsWindow.window?.screen
        anchors.fill: parent

        layer.enabled: true
        layer.effect: FastBlur {
            source: bg
            radius: 64
        }
    }

    Rectangle {
        id: shadow
        anchors.fill: parent
        color: Colors.alpha(Colors.palette.tintedShadow, 0.6)
    }

    Rectangle {
        visible: Session.packageManagerRunning || Session.downloadRunning

        anchors {
            top: parent.top
            topMargin: Appearance.spacing.xxl
            horizontalCenter: parent.horizontalCenter
        }

        implicitWidth: warnContent.implicitWidth + Appearance.spacing.md * 2
        implicitHeight: warnContent.implicitHeight + Appearance.spacing.md * 2

        radius: Appearance.rounding.full

        color: Colors.palette.m3secondaryContainer

        RowLayout {
            id: warnContent
            spacing: Appearance.spacing.lg
            anchors {
                centerIn: parent
            }

            Rectangle {
                id: warnIconContainer
                implicitWidth: warnIconContainer.implicitHeight
                implicitHeight: warnIcon.implicitHeight + Appearance.spacing.sm * 2
                radius: Appearance.rounding.full
                color: Colors.palette.m3error

                MaterialSymbol {
                    id: warnIcon

                    anchors.centerIn: parent

                    icon: Session.packageManagerRunning ? "package_2" : "download"
                    size: 40
                    color: Colors.palette.m3errorContainer
                }
            }

            ColumnLayout {
                id: warnText

                StyledText {
                    text: Translation.tr("session.warning")
                    weight: 500
                    size: Appearance.fontSize.lg
                    color: Colors.palette.m3onSecondaryContainer
                }
                StyledText {
                    text: Session.packageManagerRunning ? Translation.tr("session.pkg_running") : Translation.tr("session.down_running")
                    color: Colors.palette.m3onSecondaryContainer
                }
            }
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
                    Session.refresh();

                    if (repeater.count > 0)
                        repeater.itemAt(0).forceActiveFocus();
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

                    Elevation {
                        anchors.fill: parent
                        radius: parent.radius
                        z: -1
                        level: 4
                        opacity: 0.6
                    }

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            root.currentActionLabel = modelData.label;
                            root.currentActionDesc = modelData.desc;
                        }
                    }

                    KeyNavigation.right: (index < repeater.count - 1) ? repeater.itemAt(index + 1) : repeater.itemAt(0)
                    KeyNavigation.left: (index > 0) ? repeater.itemAt(index - 1) : repeater.itemAt(repeater.count - 1)

                    onClicked: modelData.action()
                    // onHover: btnDelegate.forceActiveFocus()
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
                color: Config.appearance.darkMode ? Colors.palette.m3onSurface : Colors.palette.m3surface
                weight: 500
                opacity: text === "" ? 0 : 1
                Behavior on opacity {
                    Anim {}
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: root.currentActionDesc
                size: Appearance.fontSize.md
                color: Colors.palette.m3outline
                opacity: text === "" ? 0 : 1
                Behavior on opacity {
                    Anim {}
                }
            }
        }
    }

    StyledText {
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: Appearance.spacing.xxl
        }

        text: `${Translation.tr("session.uptime")}: ${Time.uptime}`
        color: Colors.palette.m3outline
    }
}
