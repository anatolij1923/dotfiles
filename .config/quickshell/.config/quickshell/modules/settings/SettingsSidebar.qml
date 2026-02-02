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

    property bool collapsed: false
    required property int currentPage
    signal pageSelected(int page)

    readonly property int railWidth: 120
    readonly property int drawerWidth: 280

    implicitWidth: root.collapsed ? railWidth : drawerWidth
    color: Colors.palette.m3surfaceContainer

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
        }
    }

    Column {
        id: layout
        anchors.fill: parent
        anchors.margins: Appearance.padding.normal
        spacing: Appearance.padding.normal

        IconButton {
            id: menuBtn
            icon: root.collapsed ? "menu" : "menu_open"
            onClicked: root.collapsed = !root.collapsed
        }

        // 2. FAB / Action Button
        Rectangle {
            id: fab
            width: root.collapsed ? 56 : parent.width
            height: 56
            radius: Appearance.rounding.normal
            color: Colors.palette.m3primaryContainer
            clip: true

            x: root.collapsed ? (parent.width - width) / 2 : 0

            Behavior on width {
                Anim {
                    duration: Appearance.animDuration.expressiveFastSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                }
            }
            Behavior on x {
                Anim {
                    duration: Appearance.animDuration.expressiveFastSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                }
            }

            StateLayer {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["kitty", "-e", `${Quickshell.env("EDITOR")}`, `${Paths.strip(Paths.config)}/config.json`])
            }

            MaterialSymbol {
                id: fabIcon
                x: root.collapsed ? (parent.width - width) / 2 : Appearance.padding.large
                anchors.verticalCenter: parent.verticalCenter
                icon: "edit"
                color: Colors.palette.m3onPrimaryContainer
                Behavior on x {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
            }

            StyledText {
                anchors.left: parent.left
                anchors.leftMargin: Appearance.padding.large + 32
                anchors.verticalCenter: parent.verticalCenter
                text: "Edit Config"
                size: Appearance.font.size.small
                color: Colors.palette.m3onPrimaryContainer
                opacity: root.collapsed ? 0 : 1
                visible: opacity > 0
                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
            }
        }

        // 3. NAVIGATION ITEMS
        Column {
            width: parent.width
            spacing: 8

            Repeater {
                model: SettingsModel {}
                delegate: NavItem {
                    required property var modelData
                    required property int index

                    width: parent.width
                    icon: modelData.icon
                    label: modelData.text
                    active: index === root.currentPage
                    expanded: !root.collapsed
                    onClicked: root.pageSelected(index)
                }
            }
        }
    }

    component NavItem: Item {
        id: item
        required property string icon
        required property string label
        required property bool active
        required property bool expanded
        signal clicked

        // В Rail моде даем чуть больше места по высоте (64), чтобы влез текст
        height: expanded ? 56 : 64

        Behavior on height {
            Anim {
                duration: Appearance.animDuration.expressiveFastSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
            }
        }

        // Индикатор (Pill)
        Rectangle {
            id: indicator
            radius: Appearance.rounding.full
            color: item.active ? Colors.palette.m3secondaryContainer : "transparent"

            height: item.expanded ? 56 : 32
            width: item.expanded ? parent.width : 56

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            // В Rail моде (свернуто) отодвигаем пилюлю чуть от края, чтобы не слипалось
            anchors.topMargin: item.expanded ? 0 : 4

            Behavior on width {
                Anim {
                    duration: Appearance.animDuration.expressiveFastSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                }
            }
            Behavior on height {
                Anim {
                    duration: Appearance.animDuration.expressiveFastSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                }
            }
            Behavior on anchors.topMargin {
                Anim {
                    duration: Appearance.animDuration.expressiveFastSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                }
            }

            MaterialSymbol {
                id: iconItem
                x: item.expanded ? Appearance.padding.normal : (parent.width - width) / 2
                anchors.verticalCenter: parent.verticalCenter
                icon: item.icon
                color: item.active ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurfaceVariant

                Behavior on x {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
            }

            StyledText {
                id: drawerLabel
                anchors.left: iconItem.right
                anchors.leftMargin: Appearance.padding.normal
                anchors.verticalCenter: parent.verticalCenter
                text: item.label
                size: Appearance.font.size.small // 16px
                opacity: item.expanded ? 1 : 0
                visible: opacity > 0
                elide: Text.ElideRight
                color: item.active ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurfaceVariant

                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
            }

            StateLayer {
                anchors.fill: parent
                onClicked: item.clicked()
            }
        }

        // Текст под иконкой (только Rail)
        StyledText {
            id: railLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: indicator.bottom
            anchors.topMargin: 2
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            text: item.label
            size: Appearance.font.size.small

            opacity: item.expanded ? 0 : 1
            visible: opacity > 0
            elide: Text.ElideRight
            color: item.active ? Colors.palette.m3onSurface : Colors.palette.m3onSurfaceVariant

            Behavior on opacity {
                Anim {
                    duration: Appearance.animDuration.expressiveFastSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                }
            }
        }
    }
}
