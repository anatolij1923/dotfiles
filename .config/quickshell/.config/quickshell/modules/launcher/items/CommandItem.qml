import QtQuick
import Quickshell
import qs.modules.common
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

        // Поддержка автодополнения (как в референсном ActionItem)
        if (root.modelData.command[0] === "autocomplete" && root.modelData.command.length > 1) {
            if (root.searchField) {
                root.searchField.text = `:${root.modelData.command[1]} `;
            }
        } else {
            // Обычная команда - выполняем и закрываем лаунчер
            Quickshell.execDetached(root.modelData.command);
            GlobalStates.launcherOpened = false;
        }
    }

    StateLayer {
        anchors.fill: parent
        radius: Appearance.rounding.normal

        onClicked: {
            root.execute();
        }
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.leftMargin: Appearance.padding.normal
        anchors.rightMargin: Appearance.padding.normal

        MaterialSymbol {
            id: icon
            icon: root.modelData?.icon ?? "help_outline"
            color: Colors.palette.m3onSurfaceVariant
            size: parent.height * 0.75

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Appearance.padding.normal
            }
        }

        Column {
            id: textColumn
            anchors {
                left: icon.right
                leftMargin: Appearance.padding.small
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            // spacing: Appearance.padding.small || 2

            StyledText {
                id: nameText
                text: root.modelData?.name ?? "Unnamed Command"
                color: Colors.palette.m3onSurface
                size: 20
                weight: 500
            }

            StyledText {
                id: descText
                text: root.modelData?.description ?? ""
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
