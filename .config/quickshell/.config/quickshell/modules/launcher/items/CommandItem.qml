import QtQuick
import Quickshell
import qs.common
import qs.widgets
import qs.config
import qs.services
import qs

Item {
    id: root

    required property var modelData
    property var searchField

    implicitHeight: Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    function execute() {
        if (!root.modelData?.command || root.modelData.command.length === 0) {
            return;
        }

        if (root.modelData.command[0] === "autocomplete" && root.modelData.command.length > 1) {
            if (root.searchField) {
                root.searchField.text = `:${root.modelData.command[1]} `;
            }
        } else {
            Quickshell.execDetached(root.modelData.command);
            GlobalStates.launcherOpened = false;
        }
    }

    StateLayer {
        anchors.fill: parent
        radius: Appearance.rounding.xl

        onClicked: {
            root.execute();
        }
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.leftMargin: Appearance.spacing.md
        anchors.rightMargin: Appearance.spacing.md

        MaterialSymbol {
            id: icon
            icon: root.modelData?.icon ?? "help_outline"
            color: Colors.palette.m3onSurfaceVariant
            size: parent.height * 0.75

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Appearance.spacing.md
            }
        }

        Column {
            id: textColumn
            anchors {
                left: icon.right
                leftMargin: Appearance.spacing.md
                verticalCenter: parent.verticalCenter
                right: parent.right
            }

            StyledText {
                id: nameText
                text: (root.modelData?.highlightedName !== undefined) ? root.modelData.highlightedName : (root.modelData?.name ?? "Unnamed Command")
                color: Colors.palette.m3onSurface
                size: 20
                weight: 400
            }

            StyledText {
                id: descText
                text: (root.modelData?.highlightedDescription !== undefined && root.modelData.highlightedDescription !== root.modelData.description) ? root.modelData.highlightedDescription : (root.modelData?.description ?? "")
                color: Colors.palette.m3onSurfaceVariant
                size: 16
                opacity: 0.8
                elide: Text.ElideRight
                width: parent.width
                visible: text.length > 0
            }
        }
    }
}
