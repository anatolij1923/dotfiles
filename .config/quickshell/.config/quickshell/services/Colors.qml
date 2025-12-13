pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import qs.utils

Singleton {
    id: root

    property bool ready: false
    property bool isDarkMode: Config.appearance.darkMode
    readonly property var colors: JSON.parse(colorsFile.text()).colors[isDarkMode ? "dark" : "light"]

    property string wallpaperPath: Config.background.wallpaperPath
    property string compressedWallpaperPath: `${Paths.cache}/compressed_wallpaper`

    FileView {
        id: colorsFile

        path: Quickshell.shellPath("colors.json")
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.ready = true
    }

    function withAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    function withDarker(color, alpha) {
        return Qt.darker(color.r, color.g, color.b, alpha);
    }

    function withLighter(color, alpha) {
        return Qt.lighter(color.r, color.g, color.b, alpha);
    }

    function switchDarkLightMode() {
        Config.appearance.darkMode = !Config.appearance.darkMode;
    }

    function generateColors() {
        console.log("[COLORS] Generating material palette with matugen.");
        matugenProcess.running = true;
    }

    function compressImage() {
        console.log("[COLORS] Starting wallpaper compression (128x128).");
        convertProcess.running = true;
    }

    Connections {
        target: Config.background

        function onWallpaperPathChanged() {
            // generateColors(); // Removed comment and unnecessary call
            compressImage();
        // Removed redundant log "fsd"
        }
    }

    Process {
        id: matugenProcess
        command: ["matugen", "image", `${root.compressedWallpaperPath}`]
        onStarted: {
            console.log(`[COLORS] Matugen command started: ${matugenProcess.command.toString().replace(/,/g, " ")}`);
        }
        onExited: {
            if (exitCode === 0) {
                console.log("[COLORS] Matugen finished successfully. Colors updated via FileView.");
            } else {
                console.error(`[COLORS] Matugen failed! Exit Code: ${exitCode}. Status: ${exitStatus}.`);
                console.error("[COLORS] Matugen Output:", standardOutput);
            }
        }
    }

    Process {
        id: convertProcess
        command: ["convert", root.wallpaperPath, "-resize", "128x128", root.compressedWallpaperPath]
        onStarted: {
            console.log(`[COLORS] ImageMagick 'convert' started for: ${root.wallpaperPath}`);
        }

        onExited: {
            if (exitCode === 0) {
                console.log(`[COLORS] Wallpaper compressed successfully. Output path: ${root.compressedWallpaperPath}`);
                generateColors();
            } else {
                console.error(`[COLORS] Failed to compress wallpaper! Exit Code: ${exitCode}. Status: ${exitStatus}.`);
                console.error("[COLORS] ImageMagick Output:", standardOutput);
            }
        }
    }

    property MatugenPalette palette: MatugenPalette {}

    component MatugenPalette: JsonObject {
        readonly property color m3background: root.ready ? root.colors.background : "transparent"
        readonly property color m3error: root.ready ? root.colors.error : "transparent"
        readonly property color m3errorContainer: root.ready ? root.colors.error_container : "transparent"
        readonly property color m3inverseOnSurface: root.ready ? root.colors.inverse_on_surface : "transparent"
        readonly property color m3inversePrimary: root.ready ? root.colors.inverse_primary : "transparent"
        readonly property color m3inverseSurface: root.ready ? root.colors.inverse_surface : "transparent"
        readonly property color m3onBackground: root.ready ? root.colors.on_background : "transparent"
        readonly property color m3onError: root.ready ? root.colors.on_error : "transparent"
        readonly property color m3onErrorContainer: root.ready ? root.colors.on_error_container : "transparent"
        readonly property color m3onPrimary: root.ready ? root.colors.on_primary : "transparent"
        readonly property color m3onPrimaryContainer: root.ready ? root.colors.on_primary_container : "transparent"
        readonly property color m3onPrimaryFixed: root.ready ? root.colors.on_primary_fixed : "transparent"
        readonly property color m3onPrimaryFixedVariant: root.ready ? root.colors.on_primary_fixed_variant : "transparent"
        readonly property color m3onSecondary: root.ready ? root.colors.on_secondary : "transparent"
        readonly property color m3onSecondaryContainer: root.ready ? root.colors.on_secondary_container : "transparent"
        readonly property color m3onSecondaryFixed: root.ready ? root.colors.on_secondary_fixed : "transparent"
        readonly property color m3onSecondaryFixedVariant: root.ready ? root.colors.on_secondary_fixed_variant : "transparent"
        readonly property color m3onSurface: root.ready ? root.colors.on_surface : "transparent"
        readonly property color m3onSurfaceVariant: root.ready ? root.colors.on_surface_variant : "transparent"
        readonly property color m3onTertiary: root.ready ? root.colors.on_tertiary : "transparent"
        readonly property color m3onTertiaryContainer: root.ready ? root.colors.on_tertiary_container : "transparent"
        readonly property color m3onTertiaryFixed: root.ready ? root.colors.on_tertiary_fixed : "transparent"
        readonly property color m3onTertiaryFixedVariant: root.ready ? root.colors.on_tertiary_fixed_variant : "transparent"
        readonly property color m3outline: root.ready ? root.colors.outline : "transparent"
        readonly property color m3outlineVariant: root.ready ? root.colors.outline_variant : "transparent"
        readonly property color m3primary: root.ready ? root.colors.primary : "transparent"
        readonly property color m3primaryContainer: root.ready ? root.colors.primary_container : "transparent"
        readonly property color m3primaryFixed: root.ready ? root.colors.primary_fixed : "transparent"
        readonly property color m3primaryFixedDim: root.ready ? root.colors.primary_fixed_dim : "transparent"
        readonly property color m3scrim: root.ready ? root.colors.scrim : "transparent"
        readonly property color m3secondary: root.ready ? root.colors.secondary : "transparent"
        readonly property color m3secondaryContainer: root.ready ? root.colors.secondary_container : "transparent"
        readonly property color m3secondaryFixed: root.ready ? root.colors.secondary_fixed : "transparent"
        readonly property color m3secondaryFixedDim: root.ready ? root.colors.secondary_fixed_dim : "transparent"
        readonly property color m3shadow: root.ready ? root.colors.shadow : "transparent"
        readonly property color m3surface: root.ready ? root.colors.surface : "transparent"
        readonly property color m3surfaceBright: root.ready ? root.colors.surface_bright : "transparent"
        readonly property color m3surfaceContainer: root.ready ? root.colors.surface_container : "transparent"
        readonly property color m3surfaceContainerHigh: root.ready ? root.colors.surface_container_high : "transparent"
        readonly property color m3surfaceContainerHighest: root.ready ? root.colors.surface_container_highest : "transparent"
        readonly property color m3surfaceContainerLow: root.ready ? root.colors.surface_container_low : "transparent"
        readonly property color m3surfaceContainerLowest: root.ready ? root.colors.surface_container_lowest : "transparent"
        readonly property color m3surfaceDim: root.ready ? root.colors.surface_dim : "transparent"
        readonly property color m3surfaceTint: root.ready ? root.colors.surface_tint : "transparent"
        readonly property color m3surfaceVariant: root.ready ? root.colors.surface_variant : "transparent"
        readonly property color m3tertiary: root.ready ? root.colors.tertiary : "transparent"
        readonly property color m3tertiaryContainer: root.ready ? root.colors.tertiary_container : "transparent"
        readonly property color m3tertiaryFixed: root.ready ? root.colors.tertiary_fixed : "transparent"
        readonly property color m3tertiaryFixedDim: root.ready ? root.colors.tertiary_fixed_dim : "transparent"
    }
}
