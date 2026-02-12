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
    radius: Appearance.rounding.lg
    clip: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: headerRow.implicitHeight + Appearance.spacing.lg * 2

            RowLayout {
                id: headerRow
                anchors.centerIn: parent

                StyledText {
                    text: root.title
                    size: Appearance.fontSize.xl
                    weight: 500
                    color: Colors.palette.m3onSurface
                }
            }
        }

        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            contentWidth: width
            contentHeight: contentColumn.implicitHeight + Appearance.spacing.xl

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                anchors.rightMargin: 2
            }

            ColumnLayout {
                id: contentColumn
                width: flickable.width
                spacing: Appearance.spacing.xl
            }
        }
    }
}
