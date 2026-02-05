import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.widgets
import qs.config
import qs.services
import qs

Item {
    id: root

    required property string modelData

    implicitHeight: isImage ? (headerText.implicitHeight + layout.spacing + imgPreview.implicitHeight + Appearance.padding.normal * 2) : Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    readonly property bool isImage: ClipboardService.isImage(modelData)
    readonly property string cleanText: modelData.replace(/^\d+\t/, "").trim()

    function execute() {
        ClipboardService.paste(root.modelData);
        GlobalStates.launcherOpened = false;
    }

    StateLayer {
        anchors.fill: parent
        radius: Appearance.rounding.huge
        onClicked: root.execute()
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: Appearance.padding.normal

        Column {
            id: layout
            anchors {
                left: parent.left
                right: actionButtons.left
                rightMargin: Appearance.padding.normal
                verticalCenter: parent.verticalCenter
            }
            spacing: Appearance.padding.small

            StyledText {
                id: headerText
                width: parent.width
                text: (ClipboardService.searchResultsMap[root.modelData] !== undefined) ? ClipboardService.searchResultsMap[root.modelData] : root.cleanText
                color: Colors.palette.m3onSurface
                weight: 400
                size: root.isImage ? 16 : 18
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            ClipboardImage {
                id: imgPreview
                visible: root.isImage
                entry: root.modelData
                maxWidth: parent.width
                maxHeight: 200
            }
        }

        Row {
            id: actionButtons
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Appearance.padding.small
            z: 10

            IconButton {
                icon: "content_copy"
                radius: Appearance.rounding.small
                inactiveColor: "transparent"
                onClicked: ClipboardService.copy(root.modelData)
            }

            IconButton {
                icon: "delete"
                radius: Appearance.rounding.small
                inactiveColor: "transparent"
                onClicked: ClipboardService.remove(root.modelData)
            }
        }
    }
}
