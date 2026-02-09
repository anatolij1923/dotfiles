import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root

    default property alias contentData: contentColumn.children

    // property string icon: ""
    property string title: ""

    property int margins: Appearance.padding.huge
    property int innerMargins: Appearance.padding.large 

    Layout.fillWidth: true
    Layout.leftMargin: margins
    Layout.rightMargin: margins

    implicitHeight: mainColumn.implicitHeight

    color: Colors.palette.m3surfaceContainer
    radius: Appearance.rounding.xl

    ColumnLayout {
        id: mainColumn
        width: parent.width
        spacing: 0

        // Header with icon and title
        RowLayout {
            id: header
            Layout.fillWidth: true
            Layout.topMargin: innerMargins
            Layout.leftMargin: innerMargins
            Layout.rightMargin: innerMargins
            Layout.bottomMargin: Appearance.padding.normal
            spacing: Appearance.padding.larger

            // MaterialSymbol {
            //     icon: root.icon
            //     color: Colors.palette.m3onSurface
            //     size: 32
            //     visible: root.icon !== ""
            // }

            StyledText {
                text: root.title
                size: 22
                weight: 500
                color: Colors.palette.m3onSurface
            }
        }

        // Content area
        ColumnLayout {
            id: contentColumn
            Layout.fillWidth: true
            Layout.leftMargin: innerMargins
            Layout.rightMargin: innerMargins
            Layout.bottomMargin: innerMargins
            spacing: Appearance.padding.normal
        }
    }
}
