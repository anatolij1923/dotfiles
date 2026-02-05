import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.widgets
import qs.services
import qs.config
import qs

Item {
    id: root

    required property DesktopEntry modelData

    implicitHeight: Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    StateLayer {
        anchors.fill: parent
        radius: Appearance.rounding.huge

        onClicked: {
            root.modelData.execute();
            GlobalStates.launcherOpened = false;
        }
    }

    Item {
        id: content
        anchors.fill: parent

        IconImage {
            id: icon
            source: Quickshell.iconPath(AppSearch.guessIcon(root.modelData.icon || root.modelData.name))

            implicitSize: parent.height * 0.75
            asynchronous: true

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Appearance.padding.normal
            }
        }

        StyledText {
            text: (root.modelData.highlightedName !== undefined) ? root.modelData.highlightedName : root.modelData.name
            weight: 400
            anchors {
                left: icon.right
                verticalCenter: icon.verticalCenter
                leftMargin: Appearance.padding.smaller
            }
        }
    }
}
