pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import qs
import qs.widgets
import qs.common
import qs.services
import qs.config

Variants {
    id: root
    model: Quickshell.screens

    StyledWindow {
        id: bgRoot

        name: "background"
        required property var modelData

        property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)
        property var workspacesForMonitor: (Hyprland.workspaces?.values || []).filter(ws => ws.monitor?.name === monitor?.name)
        property int firstWorkspaceId: 1
        property int lastWorkspaceId: {
            const realIds = workspacesForMonitor.map(ws => ws.id);
            const maxId = realIds.length > 0 ? Math.max(...realIds) : 0;
            return Math.max(10, maxId);
        }
        property int range: Math.max(1, lastWorkspaceId - firstWorkspaceId)

        property string wallpaperPath: Config.ready && Config.background.wallpaperPath
        property bool isFirstImageActive: true

        onWallpaperPathChanged: {
            if (isFirstImageActive) {
                wallpaper2.source = wallpaperPath;
                isFirstImageActive = false;
            } else {
                wallpaper1.source = wallpaperPath;
                isFirstImageActive = true;
            }
        }

        property bool parallaxEnabled: Config.background.parallax.enabled
        property real wallpaperScale: Config.background.parallax.wallpaperScale
        property real movableXSpace: (bgRoot.width * wallpaperScale - bgRoot.width) / 2
        property real movableYSpace: (bgRoot.height * wallpaperScale - bgRoot.height) / 2
        property real parallaxValue: range > 0 ? (Hyprland.focusedWorkspace.id - firstWorkspaceId) / range : 0.5
        property real effectiveParallaxValue: Math.max(0, Math.min(1, parallaxValue))

        screen: modelData
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: (GlobalStates.screenLocked || GlobalStates.screenUnlocking) ? WlrLayer.Overlay : WlrLayer.Background

        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Item {
            id: imageGroup
            anchors.fill: parent
            clip: true

            Image {
                id: wallpaper1
                source: bgRoot.isFirstImageActive ? bgRoot.wallpaperPath : ""
                asynchronous: true
                cache: false
                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(bgRoot.width * wallpaperScale, bgRoot.height * wallpaperScale)
                width: bgRoot.width * wallpaperScale
                height: bgRoot.height * wallpaperScale
                x: parallaxEnabled ? -movableXSpace - (effectiveParallaxValue - 0.5) * 2 * movableXSpace : -movableXSpace
                y: -movableYSpace
                opacity: bgRoot.isFirstImageActive ? 1 : 0
                scale: bgRoot.isFirstImageActive ? 1 : 1.1

                onOpacityChanged: if (opacity === 0)
                    source = ""

                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.xl
                    }
                }
                Behavior on scale {
                    Anim {
                        duration: Appearance.animDuration.xl
                    }
                }
                Behavior on x {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Image {
                id: wallpaper2
                source: !bgRoot.isFirstImageActive ? bgRoot.wallpaperPath : ""
                asynchronous: true
                cache: false
                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(bgRoot.width * wallpaperScale, bgRoot.height * wallpaperScale)
                width: bgRoot.width * wallpaperScale
                height: bgRoot.height * wallpaperScale
                x: parallaxEnabled ? -movableXSpace - (effectiveParallaxValue - 0.5) * 2 * movableXSpace : -movableXSpace
                y: -movableYSpace
                opacity: !bgRoot.isFirstImageActive ? 1 : 0
                scale: !bgRoot.isFirstImageActive ? 1 : 1.1

                onOpacityChanged: if (opacity === 0)
                    source = ""

                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.xl
                    }
                }
                Behavior on scale {
                    Anim {
                        duration: Appearance.animDuration.xl
                    }
                }
                Behavior on x {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        ShaderEffectSource {
            id: wallpaperSource
            sourceItem: imageGroup
            anchors.fill: parent
            visible: false
            live: true
            recursive: false
        }

        Loader {
            id: blurLoader
            active: (GlobalStates.screenLocked || GlobalStates.screenUnlocking) && Config.lock.blur.enabled

            opacity: (GlobalStates.screenLocked && !GlobalStates.screenUnlocking) ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                Anim {
                    duration: Appearance.animDuration.lg
                }
            }

            anchors.fill: parent
            sourceComponent: GaussianBlur {
                anchors.fill: parent
                source: wallpaperSource
                radius: Config.lock.blur.radius
                samples: radius
            }
        }

        Loader {
            id: dimLoader
            property bool shouldShow: GlobalStates.launcherOpened || GlobalStates.overviewOpened || GlobalStates.quicksettingsOpened || GlobalStates.powerMenuOpened
            active: Config.background.dim.enabled && (shouldShow || opacity > 0)
            anchors.fill: parent
            opacity: shouldShow ? 1 : 0
            Behavior on opacity {
                Anim {}
            }
            sourceComponent: Rectangle {
                color: Qt.alpha("black", Config.background.dim.opacity)
            }
        }
    }
}
