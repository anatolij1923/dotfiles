import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root
    default property alias contentData: contentColumn.children
    property string title: ""

    Layout.fillWidth: true
    implicitHeight: mainColumn.implicitHeight + Appearance.spacing.lg * 2

    color: Colors.alpha(Colors.palette.m3surfaceContainer, 0.6)
    radius: Appearance.rounding.xl

    ColumnLayout {
        id: mainColumn
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Appearance.spacing.lg 
        }
        spacing: Appearance.spacing.md

        StyledText {
            text: root.title
            size: Appearance.fontSize.md
            weight: 600
            color: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.5)
            visible: text !== ""
            Layout.bottomMargin: Appearance.spacing.xs
        }

        ColumnLayout {
            id: contentColumn
            Layout.fillWidth: true
            spacing: Appearance.spacing.sm 
        }
    }
}
