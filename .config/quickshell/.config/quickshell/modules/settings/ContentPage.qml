import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root
    required property string title
    default property alias content: contentColumn.children

    color: Colors.palette.m3surface 
    radius: Appearance.rounding.xl

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 80 

            StyledText {
                text: root.title
                size: Appearance.fontSize.xl
                weight: 750
                color: Colors.palette.m3onSurface
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: Appearance.spacing.xl
                }
            }
        }

        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            contentWidth: width
            contentHeight: contentColumn.implicitHeight + Appearance.spacing.xxxl

            ScrollBar.vertical: ScrollBar {
                id: scroll
                policy: ScrollBar.AsNeeded
                width: 4
                background: null
                contentItem: Rectangle {
                    implicitWidth: 4
                    radius: 2
                    color: Colors.palette.m3outline
                    opacity: scroll.active || scroll.hovered ? 0.5 : 0
                    Behavior on opacity { CAnim { duration: 200 } }
                }
            }

            ColumnLayout {
                id: contentColumn
                width: parent.width - Appearance.spacing.xl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Appearance.spacing.lg 
            }
        }
    }
}
