import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    required property string title

    default property alias content: contentColumn.children

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Fixed header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: headerRow.implicitHeight + Appearance.padding.large * 2
            color: Colors.palette.m3surface

            RowLayout {
                id: headerRow
                anchors.centerIn: parent
                width: parent.width

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    text: root.title
                    size: 30
                    weight: 500
                    color: Colors.palette.m3onSurface
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }

        // Scrollable content
        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            contentWidth: width
            contentHeight: Math.max(contentColumn.childrenRect.height, contentColumn.implicitHeight)

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            ColumnLayout {
                id: contentColumn
                width: flickable.width
                spacing: Appearance.padding.huge
            }
        }
    }
}
