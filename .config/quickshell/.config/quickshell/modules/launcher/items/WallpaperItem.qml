import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.widgets
import qs.config
import qs.services
import qs

Item {
    id: root

    required property string wallpaperPath
    readonly property bool isCurrent: ListView.isCurrentItem

    // Calculate relative path from the base wallpaper directory
    readonly property string relativePath: wallpaperPath.replace(Wallpapers.wallpaperDir + "/", "")

    implicitWidth: Config.launcher.sizes.wallWidth
    // Extra height for text label and animation padding
    implicitHeight: Config.launcher.sizes.wallHeight + 60

    z: isCurrent ? 10 : 1
    opacity: isCurrent ? 1.0 : 0.7

    Behavior on opacity {
        Anim {}
    }

    function execute() {
        Wallpapers.setWallpaper(root.wallpaperPath);
    }

    StateLayer {
        anchors.fill: parent
        radius: Appearance.rounding.normal
        z: 100
        onClicked: root.execute()
    }

    Column {
        anchors.centerIn: parent
        width: parent.width
        spacing: 10

        ClippingRectangle {
            id: imgContainer
            width: parent.width

            height: Config.launcher.sizes.wallHeight

            radius: Appearance.rounding.normal
            color: Colors.palette.m3surfaceContainer
            clip: true

            border.color: Colors.palette.m3primary
            border.width: isCurrent ? 3 : 0

            Image {
                anchors.fill: parent
                source: root.wallpaperPath.startsWith("/") ? "file://" + root.wallpaperPath : root.wallpaperPath
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                smooth: true
                sourceSize {
                    width: Config.launcher.wallWidth
                    height: Config.launcher.wallHeight
                }
            }

            // Indicator for currently active wallpaper
            Rectangle {
                anchors.fill: parent
                color: Colors.palette.m3primary
                opacity: Wallpapers.actualCurrent === root.wallpaperPath ? 0.2 : 0
                radius: Appearance.rounding.normal
            }
        }

        StyledText {
            id: label
            width: parent.width
            text: root.relativePath

            // Change font size and weight based on focus state
            size: isCurrent ? 18 : 16
            weight: isCurrent ? 600 : 400

            color: isCurrent ? Colors.palette.m3onSurface : Colors.palette.m3onSurfaceVariant
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideMiddle
            maximumLineCount: 1

            // Behavior on size {
            //     Anim {}
            // }
        }
    }
}
