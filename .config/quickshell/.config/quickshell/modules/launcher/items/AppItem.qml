import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.modules.common
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
        radius: Appearance.rounding.normal

        onClicked: {
            root.modelData.execute(
            )
            GlobalStates.launcherOpened = false
        }
    }

    Item {
        id: content
        anchors.fill: parent

        IconImage {
            id: icon
            source: Quickshell.iconPath(AppSearch.guessIcon(root.modelData.icon || root.modelData.name))

            implicitSize: parent.height * 0.75

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Appearance.padding.normal
            }
        }

        StyledText {
            text: root.modelData.name
            anchors {
                left: icon.right
                verticalCenter: icon.verticalCenter
                leftMargin: Appearance.padding.small
            }
        }
    }
}
