import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root

    property bool collapsed: false
    required property int currentPage
    signal pageSelected(int page)

    implicitWidth: collapsed ? 100 : 250
    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }
    color: Colors.palette.m3surfaceContainer

    Rectangle {
        id: separator
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Colors.palette.m3surfaceContainerHigh
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: Appearance.padding.normal
        }
        spacing: Appearance.padding.normal

        Item {
            id: header
            implicitHeight: collapseButton.implicitHeight

            Layout.leftMargin: Appearance.padding.normal * 2
            Layout.topMargin: Appearance.padding.normal
            Layout.bottomMargin: Appearance.padding.normal

            IconButton {
                id: collapseButton
                icon: root.collapsed ? "menu" : "menu_open"
                iconSize: 30

                onClicked: {
                    root.collapsed = !root.collapsed;
                }
            }
        }

        Item {
            implicitHeight: configEditButton.implicitHeight

            TextIconButton {
                id: configEditButton
                icon: "edit"
                text: root.collapsed ? "" : "Config"

                inactiveColor: Colors.palette.m3primaryContainer
                padding: Appearance.padding.larger
                radius: Appearance.rounding.normal

                onClicked: {
                    Quickshell.execDetached(["kitty", "-e", `${Quickshell.env("EDITOR")}`, `${Paths.strip(Paths.config)}/config.json`]);
                }

                StyledTooltip {
                    text: "Open config.json with your $EDITOR"
                    horizontalPadding: Appearance.padding.large
                    verticalPadding: Appearance.padding.normal
                }
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            interactive: true

            contentWidth: width
            contentHeight: contentColumn.implicitHeight

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            ColumnLayout {
                id: contentColumn
                width: parent.width
                spacing: Appearance.padding.normal

                Repeater {
                    model: SettingsModel {}

                    delegate: TextIconButton {
                        Layout.fillWidth: true

                        icon: model.icon
                        iconColor: Colors.palette.m3secondary
                        text: root.collapsed ? "" : model.text
                        textSize: 18
                        textWeight: checked ? 500 : 400
                        textColor: Colors.palette.m3secondary
                        checked: index === root.currentPage
                        verticalPadding: Appearance.padding.normal
                        activeColor: Colors.palette.m3secondaryContainer

                        onClicked: root.pageSelected(index)
                    }
                }
            }
        }
    }
}
