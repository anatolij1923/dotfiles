pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import Qt5Compat.GraphicalEffects
import qs.common
import qs.widgets
import qs
import qs.services
import qs.config

Variants {
    model: Quickshell.screens

    StyledWindow {
        id: root
        required property var modelData

        name: "background"
        screen: modelData

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        WlrLayershell.layer: (GlobalStates.screenLocked || GlobalStates.screenUnlocking) ? WlrLayer.Overlay : WlrLayer.Background
        exclusionMode: ExclusionMode.Ignore

        property bool shouldDim: GlobalStates.launcherOpened || GlobalStates.overviewOpened || GlobalStates.quicksettingsOpened || GlobalStates.dashboardOpened || GlobalStates.mediaplayerOpened
        property bool isLocked: GlobalStates.screenLocked

        property bool zoomEnabled: Config.background.zoom.enabled
        property real zoomScale: Config.background.zoom.scale
        property real activeScale: (zoomEnabled && shouldDim) ? zoomScale : 1.0

        property bool parallaxEnabled: Config.background.parallax.enabled
        property real parallaxFactor: Config.background.parallax.wallpaperScale
        property string wallpaperPath: Config.ready ? Config.background.wallpaperPath : ""

        property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)
        property var workspacesForMonitor: (Hyprland.workspaces?.values || []).filter(ws => ws.monitor?.name === root.monitor?.name)

        property int firstWorkspaceId: 1
        property int lastWorkspaceId: {
            const realIds = workspacesForMonitor.map(ws => ws.id);
            const maxId = realIds.length > 0 ? Math.max(...realIds) : 0;
            return Math.max(10, maxId);
        }
        property int range: Math.max(1, lastWorkspaceId - firstWorkspaceId)

        property real parallaxValue: range > 0 ? (Hyprland.focusedWorkspace.id - firstWorkspaceId) / range : 0.5
        property real effectiveParallax: Math.max(0, Math.min(1, parallaxValue))

        property real movableX: (root.width * parallaxFactor - root.width) / 2
        property real movableY: (root.height * parallaxFactor - root.height) / 2

        Item {
            id: wallpaperViewport
            anchors.fill: parent
            clip: true

            StyledImage {
                id: wallpaper

                width: root.parallaxEnabled ? root.width * root.parallaxFactor : root.width
                height: root.parallaxEnabled ? root.height * root.parallaxFactor : root.height

                x: root.parallaxEnabled ? -root.movableX - (root.effectiveParallax - 0.5) * 2 * root.movableX : 0
                y: root.parallaxEnabled ? -root.movableY : 0

                source: root.wallpaperPath

                scale: (status === Image.Ready) ? root.activeScale : 1.1

                sourceSize: Qt.size(width, height)

                Behavior on x {
                    enabled: root.parallaxEnabled
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on scale {
                    Anim {
                        duration: Appearance.animDuration.md
                    }
                }
            }
        }

        ShaderEffectSource {
            id: wallpaperSource
            sourceItem: wallpaperViewport
            anchors.fill: parent

            live: root.isLocked || blurLoader.opacity > 0
            hideSource: false
            visible: false
        }

        Loader {
            id: blurLoader
            anchors.fill: parent
            active: Config.lock.blur.enabled && (root.isLocked || opacity > 0)
            opacity: root.isLocked ? 1 : 0

            Behavior on opacity {
                Anim {
                    duration: Appearance.animDuration.md
                }
            }

            sourceComponent: GaussianBlur {
                anchors.fill: parent
                source: wallpaperSource
                radius: Config.lock.blur.radius
                samples: radius
            }
        }

        Loader {
            id: dimLoader
            anchors.fill: parent
            active: Config.background.dim.enabled && (root.shouldDim || opacity > 0)
            opacity: root.shouldDim ? 1 : 0

            Behavior on opacity {
                Anim {
                    duration: Appearance.animDuration.lg
                }
            }

            sourceComponent: Rectangle {
                color: Colors.alpha(Colors.palette.tintedShadow, Config.background.dim.opacity)
            }
        }
    }
}
