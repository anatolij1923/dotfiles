pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.widgets
import qs.config
import qs.services

Item {
    id: root
    required property var modelData // { emoji, description }

    implicitHeight: Config.launcher.sizes.itemHeight
    anchors.left: parent?.left
    anchors.right: parent?.right

    function execute() {
        EmojisService.copyAndType(modelData.emoji);
    }

    StateLayer {
        anchors.fill: parent
        radius: Appearance.rounding.xl
        onClicked: root.execute()
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: Appearance.padding.normal
        anchors.rightMargin: Appearance.padding.normal
        spacing: Appearance.padding.normal

        StyledText {
            text: modelData.emoji
            size: 32
            anchors.verticalCenter: parent.verticalCenter
        }

        StyledText {
            text: (modelData.highlightedDescription !== undefined) ? modelData.highlightedDescription : modelData.description
            color: Colors.palette.m3onSurface
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 65
        }
    }
}
