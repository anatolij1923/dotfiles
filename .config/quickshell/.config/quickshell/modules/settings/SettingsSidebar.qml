pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root

    required property int currentPage
    signal pageSelected(int page)

    implicitWidth: 280
    color: Colors.palette.m3surfaceContainer

    ColumnLayout {
        anchors.fill: parent
        anchors {
            leftMargin: Appearance.spacing.lg
            rightMargin: Appearance.spacing.sm
            topMargin: Appearance.spacing.lg
            bottomMargin: Appearance.spacing.lg
        }
        spacing: Appearance.spacing.xs

        StyledText {
            text: Translation.tr("settings.settings")
            size: Appearance.fontSize.lg
            weight: Font.DemiBold
            color: Colors.palette.m3onSurface
            Layout.leftMargin: Appearance.spacing.md
            Layout.topMargin: Appearance.spacing.md
            Layout.bottomMargin: Appearance.spacing.xl
        }

        Repeater {
            model: SettingsModel {}
            delegate: NavItem {}
        }

        Item {
            Layout.fillHeight: true
        }

        Rectangle {
            id: editConfigBtn
            Layout.fillWidth: true
            implicitHeight: 56
            radius: Appearance.rounding.md
            color: Colors.palette.m3surfaceContainerHigh

            StateLayer {
                onClicked: {
                    Quickshell.execDetached(["ghostty", "-e", Quickshell.env("EDITOR") || "nvim", `${Quickshell.shellDir}/config.json`]);
                }
            }

            RowLayout {
                anchors.centerIn: parent
                spacing: Appearance.spacing.md

                MaterialSymbol {
                    icon: "edit"
                    size: 20
                    color: Colors.palette.m3primary
                }

                StyledText {
                    text: Translation.tr("settings.edit_config")
                    color: Colors.palette.m3onSurfaceVariant
                    size: Appearance.fontSize.sm
                    weight: 500
                }
            }
        }
    }

    component NavItem: Rectangle {
        id: item

        required property var modelData
        required property int index

        readonly property bool active: root.currentPage === index

        Layout.fillWidth: true
        implicitHeight: 48
        radius: Appearance.rounding.full 

        color: active ? Colors.palette.m3secondaryContainer : Colors.palette.m3surfaceContainer

        Behavior on color {
            CAnim {

            }
        }

        StateLayer {
            id: stateLayer
            color: item.active ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
            onClicked: root.pageSelected(item.index)
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Appearance.spacing.lg
            anchors.rightMargin: Appearance.spacing.lg
            spacing: Appearance.spacing.md

            MaterialSymbol {
                icon: item.modelData.icon
                size: 24
                color: item.active ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurfaceVariant

                Behavior on color {
                    CAnim {
                        duration: Appearance.animDuration.expressiveEffects
                    }
                }
            }

            StyledText {
                Layout.fillWidth: true
                text: Translation.tr(item.modelData.textKey)
                color: item.active ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurfaceVariant
                size: Appearance.fontSize.sm
                weight: item.active ? 550 : 450

                Behavior on color {
                    CAnim {
                        duration: Appearance.animDuration.expressiveEffects
                    }
                }
            }

            Rectangle {
                implicitWidth: 4
                implicitHeight: 4
                radius: 2
                color: Colors.palette.m3primary
                visible: item.active
                opacity: item.active ? 1 : 0
                Behavior on opacity {
                    Anim {
                        duration: 200
                    }
                }
            }
        }
    }
}
