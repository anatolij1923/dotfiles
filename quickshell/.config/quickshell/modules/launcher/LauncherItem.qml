import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs

Rectangle {
    id: root
    property var desktopEntry: null
    property bool isCurrent: false

    width: parent ? parent.width : 460
    implicitHeight: containerItem.height + 32
    color: isCurrent ? Colors.on_secondary_fixed_variant : "transparent"
    radius: 16

    StateLayer {
            anchors.fill: parent // Занимает всю область родителя (containerItem)
            radius: root.radius // Передаем радиус из корневого элемента LauncherItem
            onClicked: { // Обрабатываем клик
                if (root.desktopEntry) {
                    root.desktopEntry.execute();
                    root.activated();
                }
            }
            onEntered: resultsView.currentIndex = index // Обрабатываем наведение
        }

    signal activated

    Item {
        id: containerItem

        anchors {
            fill: parent
            margins: 8
        }

        RowLayout {
            id: row
            anchors.fill: parent
            spacing: 10

            Image {
                id: icon
                Layout.preferredWidth: 35
                Layout.preferredHeight: 35
                fillMode: Image.PreserveAspectFit
                source: Quickshell.iconPath(AppSearch.guessIcon(desktopEntry.icon || desktopEntry.name))
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                id: label
                Layout.fillWidth: true
                text: desktopEntry.name
                color: Colors.on_surface
                size: 18
                weight: 400
                elide: Text.ElideRight
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        

    }

    // MouseArea {
    //     anchors.fill: parent
    //     hoverEnabled: true
    //     onClicked: {
    //         if (desktopEntry) {
    //             desktopEntry.execute();
    //             root.activated();
    //         }
    //     }
    //     onEntered: resultsView.currentIndex = index
    // }
}
