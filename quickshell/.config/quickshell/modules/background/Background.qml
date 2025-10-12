pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import qs
import qs.services

Variants {
    id: root
    model: Quickshell.screens

    PanelWindow {
        id: bgRoot

        required property var modelData

        // Workspace tracking for parallax
        property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)
        property var workspacesForMonitor: (Hyprland.workspaces?.values || []).filter(ws => ws.monitor?.name === monitor?.name)
        property int firstWorkspaceId: 1
        property int lastWorkspaceId: {
            const realIds = workspacesForMonitor.map(ws => ws.id);
            const maxId = realIds.length > 0 ? Math.max(...realIds) : 0;
            return Math.max(10, maxId);
        }
        property int range: Math.max(1, lastWorkspaceId - firstWorkspaceId)

        property bool startAnimation: false

        // Parallax calculation properties
        property real wallpaperScale: 1.1 // Zoom factor to enable parallax movement
        property real movableXSpace: (bgRoot.width * wallpaperScale - bgRoot.width) / 2
        property real movableYSpace: (bgRoot.height * wallpaperScale - bgRoot.height) / 2
        property real parallaxValue: range > 0 ? (Hyprland.focusedWorkspace.id - firstWorkspaceId) / range : 0.5
        property real effectiveParallaxValue: Math.max(0, Math.min(1, parallaxValue))

        screen: modelData
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: GlobalStates.screenLocked ? WlrLayer.Overlay : WlrLayer.Bottom
        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        // Wallpaper
        Item {
            anchors.fill: parent
            clip: true

            Image {
                id: wallpaper
                asynchronous: true
                fillMode: Image.PreserveAspectCrop

                x: -movableXSpace - (effectiveParallaxValue - 0.5) * 2 * movableXSpace
                y: -movableYSpace

                Behavior on x {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutCubic
                    }
                }

                sourceSize: Qt.size(bgRoot.width * wallpaperScale, bgRoot.height * wallpaperScale)
                width: bgRoot.width * wallpaperScale
                height: bgRoot.height * wallpaperScale
                source: "file:///home/anatolij1923/Изображения/wallpapers/Girls/random_wallpaper.jpg"

            }

            Loader {
                id: blurLoader
                active: GlobalStates.screenLocked
                anchors.fill: wallpaper
                scale: GlobalStates.screenLocked ? 1.05 : 1

                Behavior on scale {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutExpo
                    }
                }

                sourceComponent: GaussianBlur {
                    opacity: bgRoot.startAnimation ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.InOutExpo
                        }
                    }
                    source: wallpaper
                    radius: 30
                    samples: radius * 2
                }

                Connections {
                    target: GlobalStates
                    function onScreenLockedChanged() {
                        if (GlobalStates.screenLocked) {
                            bgRoot.startAnimation = true;
                        } else {
                            bgRoot.startAnimation = false;
                        }
                    }
                }
            }
        }
    }
}
