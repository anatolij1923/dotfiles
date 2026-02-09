pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root

    property bool collapsed: true
    readonly property bool expanded: !collapsed

    required property int currentPage
    signal pageSelected(int page)

    readonly property int railWidth: 120
    readonly property int drawerWidth: 240

    color: Colors.palette.m3surfaceContainer

    implicitWidth: collapsed ? railWidth : drawerWidth
    implicitHeight: layout.implicitHeight + Appearance.spacing.lg * 2

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
        }
    }
    Behavior on implicitHeight {
        Anim {
            duration: Appearance.animDuration.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
        }
    }

    ColumnLayout {
        id: layout

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.leftMargin: Appearance.spacing.lg
        anchors.rightMargin: Appearance.spacing.sm
        anchors.topMargin: Appearance.spacing.lg
        spacing: Appearance.spacing.md

        // states: State {
        //     name: "expanded"
        //     when: root.expanded
        //
        //     PropertyChanges {
        //         layout.spacing: Appearance.spacing.sm
        //     }
        // }
        //
        // transitions: Transition {
        //     Anim {
        //         properties: "spacing"
        //         duration: Appearance.animDuration.expressiveFastSpatial
        //         easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        //     }
        // }

        IconButton {
            id: menuBtn
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Appearance.spacing.lg
            icon: root.collapsed ? "menu" : "menu_open"
            onClicked: root.collapsed = !root.collapsed
        }

        Rectangle {
            id: fab

            readonly property int fabSize: 64

            Layout.alignment: root.collapsed ? Qt.AlignHCenter : Qt.AlignLeft
            // Layout.leftMargin: root.collapsed ? 0 : Appearance.spacing.sm

            implicitHeight: fabSize
            implicitWidth: root.collapsed ? fabSize : expandedRow.implicitWidth + Appearance.spacing.lg * 2

            color: Colors.palette.m3primaryContainer
            radius: Appearance.rounding.lg
            clip: true

            Behavior on implicitWidth {
                Anim {
                    duration: Appearance.animDuration.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                }
            }

            StateLayer {
                id: fabState
                color: Colors.palette.m3onPrimaryContainer
                onClicked: {
                    Quickshell.execDetached(["kitty", "-e", Quickshell.env("EDITOR") || "nvim", `${Quickshell.shellDir}/config.json`]);
                }
            }

            Row {
                id: expandedRow
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: (fab.fabSize - editIcon.width) / 2
                spacing: Appearance.spacing.md

                MaterialSymbol {
                    id: editIcon
                    icon: "edit"
                    size: 24
                    color: Colors.palette.m3onPrimaryContainer
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    id: editLabel
                    text: Translation.tr("settings.edit_config")
                    color: Colors.palette.m3onPrimaryContainer
                    anchors.verticalCenter: parent.verticalCenter

                    // Текст плавно исчезает/появляется
                    opacity: root.expanded ? 1 : 0
                    visible: opacity > 0

                    Behavior on opacity {
                        Anim {
                            duration: Appearance.animDuration.expressiveFastSpatial
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 12
        }

        Repeater {
            model: SettingsModel {}

            delegate: NavItem {}
        }
    }

    component NavItem: Item {
        id: item

        required property var modelData
        required property int index

        readonly property string icon: modelData.icon
        readonly property string label: Translation.tr(modelData.textKey)

        readonly property bool active: root.currentPage === index

        implicitWidth: background.implicitWidth
        implicitHeight: background.implicitHeight + smallLabel.implicitHeight + smallLabel.anchors.topMargin

        Layout.alignment: root.collapsed ? Qt.AlignHCenter : Qt.AlignLeft

        states: State {
            name: "expanded"
            when: root.expanded

            PropertyChanges {
                expandedLabel.opacity: 1
                smallLabel.opacity: 0
                background.implicitWidth: iconItem.implicitWidth + iconItem.anchors.leftMargin * 2 + expandedLabel.anchors.leftMargin + expandedLabel.implicitWidth
                background.implicitHeight: iconItem.implicitHeight + Appearance.spacing.md * 2
                item.implicitHeight: background.implicitHeight
            }
        }

        transitions: Transition {
            Anim {
                property: "opacity"
                duration: Appearance.animDuration.expressiveFastSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
            }

            Anim {
                properties: "implicitWidth,implicitHeight"
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
        }

        Rectangle {
            id: background

            radius: Appearance.rounding.full
            color: Qt.alpha(Colors.palette.m3secondaryContainer, item.active ? 1 : 0)

            implicitWidth: iconItem.implicitWidth + iconItem.anchors.leftMargin * 2
            implicitHeight: iconItem.implicitHeight + Appearance.spacing.sm

            StateLayer {
                color: item.active ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface

                function onClicked(): void {
                    root.pageSelected(item.index);
                }
            }

            MaterialSymbol {
                id: iconItem

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Appearance.spacing.lg

                icon: item.icon
                color: item.active ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
            }

            StyledText {
                id: expandedLabel

                anchors.left: iconItem.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Appearance.spacing.md

                opacity: 0
                text: item.label
                color: item.active ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
            }

            StyledText {
                id: smallLabel

                anchors.horizontalCenter: iconItem.horizontalCenter
                anchors.top: iconItem.bottom
                anchors.topMargin: Appearance.spacing.sm / 2

                text: item.label
                size: Appearance.fontSize.sm
            }
        }
    }
}
