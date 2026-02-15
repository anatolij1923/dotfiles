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

    readonly property string relativePath: wallpaperPath.replace(Wallpapers.wallpaperDir + "/", "")

    implicitWidth: Config.launcher.sizes.wallWidth
    implicitHeight: Config.launcher.sizes.wallHeight + 80

    z: isCurrent ? 10 : 1

    opacity: isCurrent ? 1.0 : 0.8
    Behavior on opacity {
        Anim {}
    }

    function execute() {
        Wallpapers.setWallpaper(root.wallpaperPath);
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.execute()
    }

    Item {
        id: visualContainer
        anchors.centerIn: parent

        width: isCurrent ? Math.round(root.implicitWidth * 1.1) : root.implicitWidth
        height: isCurrent ? Math.round(Config.launcher.sizes.wallHeight * 1.2) : Config.launcher.sizes.wallHeight

        y: isCurrent ? -15 : 0

        Behavior on width {
            Anim {
                duration: 350
            }
        }
        Behavior on height {
            Anim {
                duration: 350
            }
        }
        Behavior on y {
            Anim {
                duration: 350
            }
        }

        Column {
            anchors.fill: parent
            spacing: 12

            ClippingRectangle {
                width: parent.width
                height: parent.height - (label.height + parent.spacing)

                radius: Appearance.rounding.lg
                color: Colors.palette.m3surfaceContainer
                clip: true

                StyledImage {
                    anchors.fill: parent
                    source: root.wallpaperPath.startsWith("/") ? "file://" + root.wallpaperPath : root.wallpaperPath
                    smooth: true
                    sourceSize {
                        width: Math.round(Config.launcher.sizes.wallWidth + 100)
                        height: Math.round(Config.launcher.sizes.wallHeight + 100)
                    }
                }
            }

            StyledText {
                id: label
                width: parent.width
                text: root.relativePath

                size: isCurrent ? Appearance.fontSize.md : Appearance.fontSize.sm
                weight: isCurrent ? 600 : 400

                color: isCurrent ? Colors.palette.m3onSurface : Colors.palette.m3onSurfaceVariant

                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideMiddle
                maximumLineCount: 1

                Behavior on size {
                    Anim {}
                }
                Behavior on color {
                    CAnim {}
                }
            }
        }
    }
}
