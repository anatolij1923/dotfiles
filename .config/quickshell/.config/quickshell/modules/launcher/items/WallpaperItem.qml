import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.modules.common
import qs.config
import qs.services
import qs

Item {
    id: root

    required property string wallpaperPath

    implicitWidth: Config.launcher.sizes.wallWidth
    implicitHeight: Config.launcher.sizes.wallHeight

    Component.onCompleted: {
        console.log("WallpaperItem.qml: Component created with path =", wallpaperPath);
    }

    StateLayer {
        id: stateLayer
        anchors.fill: parent
        radius: Appearance.rounding.normal

        z: 100

        onClicked: {
            Wallpapers.setWallpaper(root.wallpaperPath);
            // GlobalStates.launcherOpened = false;
        }
    }

    ClippingRectangle {
        id: imageContainer
        anchors.fill: parent
        radius: Appearance.rounding.normal
        color: Colors.palette.m3surfaceContainer
        clip: true

        Image {
            id: wallpaperImage
            anchors.fill: parent
            source: root.wallpaperPath
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            smooth: true
            cache: true

            sourceSize.width: root.implicitWidth
            sourceSize.height: root.implicitHeight

            // Component.onCompleted: {
            //     console.log("WallpaperItem.qml: Image component created, source =", root.wallpaperPath);
            // }
            //
            // onStatusChanged: {
            //     console.log("WallpaperItem.qml: Image status changed to", status, "for", root.wallpaperPath);
            //     if (status === Image.Loading) {
            //         console.log("WallpaperItem.qml: Loading image from", root.wallpaperPath);
            //     } else if (status === Image.Ready) {
            //         console.log("WallpaperItem.qml: Image loaded successfully, size =", sourceSize.width, "x", sourceSize.height);
            //     } else if (status === Image.Error) {
            //         console.error("WallpaperItem.qml: Failed to load image from", root.wallpaperPath);
            //     }
            // }
            //
            // onSourceChanged: {
            //     console.log("WallpaperItem.qml: Image source changed to", source);
            // }
        }

        // Overlay for current wallpaper indicator
        Rectangle {
            anchors.fill: parent
            color: Colors.palette.m3primary
            opacity: Wallpapers.actualCurrent === root.wallpaperPath ? 0.3 : 0
            radius: Appearance.rounding.normal

            Behavior on opacity {
                Anim {
                    duration: Appearance.animDuration.standard
                }
            }
        }

        // Border for current wallpaper
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: Colors.palette.m3primary
            border.width: Wallpapers.actualCurrent === root.wallpaperPath ? 2 : 0
            radius: Appearance.rounding.normal

            Behavior on border.width {
                Anim {
                    duration: Appearance.animDuration.standard
                }
            }
        }
    }

    StyledTooltip {
        text: root.wallpaperPath
        extraVisibleCondition: stateLayer.containsMouse
    }
}
