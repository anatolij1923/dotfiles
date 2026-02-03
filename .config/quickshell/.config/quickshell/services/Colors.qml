pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import qs.common
import qs.services

Singleton {
    id: root

    property bool ready: false
    property bool isDarkMode: Config.appearance.darkMode

    property string matugenMode: Config.appearance.theming.matugenMode
    readonly property var colors: JSON.parse(colorsFile.text()).colors[isDarkMode ? "dark" : "light"]

    property string wallpaperPath: Config.background.wallpaperPath

    function switchDarkLightMode() {
        Config.appearance.darkMode = !Config.appearance.darkMode;
    }

    function generateColors() {
        if (wallpaperPath === "")
            return;

        // if (kmycProc.running) {
        //     kmycProc.running = false;
        // }

        if (Config.ready) {
            matugenProc.running = true;
            // kmycProc.running = true;
        }
    }

    Process {
        id: matugenProc
        command: ["matugen", "-c", Quickshell.shellPath("matugen/config.toml"), "-t", root.matugenMode, "image", root.wallpaperPath]

        onStarted: {
            Logger.i("COLORS", `Generating colors with matugen`);
            Logger.i("COLORS", `${matugenProc.command.toString().replace(",", " ")}`);
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                Logger.s("COLORS", "Successfully generated color palette");
            } else {
                Logger.e("COLORS", `Failed to generate colors. Error: ${exitStatus}`);
            }
        }
    }

    // Process {
    //     id: kmycProc
    //     command: ["kde-material-you-colors", "--file", root.wallpaperPath]
    //
    //     onStarted: {
    //         Logger.i("COLORS", "Generating colors with kde-material-colors");
    //     }
    //
    //     onExited: (exitCode, exitStatus) => {
    //         if (exitCode === 0) {
    //             Logger.s("COLORS", "KDE colors updated successfully");
    //         } else {
    //             Logger.e("COLORS", `KMYC failed. Code: ${exitCode}`);
    //         }
    //     }
    // }

    // Connections {
    //     target: Config.background
    //
    //     function onWallpaperPathChanged() {
    //         generateColors();
    //     }
    // }

    FileView {
        id: colorsFile

        path: `${Quickshell.shellDir}/colors.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.ready = true
    }

    property MatugenPalette palette: MatugenPalette {}

    component MatugenPalette: JsonObject {
        readonly property color m3background: root.ready ? root.colors.background : "#111318"
        readonly property color m3error: root.ready ? root.colors.error : "#ffb4ab"
        readonly property color m3errorContainer: root.ready ? root.colors.error_container : "#93000a"
        readonly property color m3inverseOnSurface: root.ready ? root.colors.inverse_on_surface : "#2e3036"
        readonly property color m3inversePrimary: root.ready ? root.colors.inverse_primary : "#405f90"
        readonly property color m3inverseSurface: root.ready ? root.colors.inverse_surface : "#e2e2e9"
        readonly property color m3onBackground: root.ready ? root.colors.on_background : "#e2e2e9"
        readonly property color m3onError: root.ready ? root.colors.on_error : "#690005"
        readonly property color m3onErrorContainer: root.ready ? root.colors.on_error_container : "#ffdad6"
        readonly property color m3onPrimary: root.ready ? root.colors.on_primary : "#08305f"
        readonly property color m3onPrimaryContainer: root.ready ? root.colors.on_primary_container : "#d6e3ff"
        readonly property color m3onPrimaryFixed: root.ready ? root.colors.on_primary_fixed : "#001b3d"
        readonly property color m3onPrimaryFixedVariant: root.ready ? root.colors.on_primary_fixed_variant : "#264777"
        readonly property color m3onSecondary: root.ready ? root.colors.on_secondary : "#283141"
        readonly property color m3onSecondaryContainer: root.ready ? root.colors.on_secondary_container : "#d9e3f9"
        readonly property color m3onSecondaryFixed: root.ready ? root.colors.on_secondary_fixed : "#121c2b"
        readonly property color m3onSecondaryFixedVariant: root.ready ? root.colors.on_secondary_fixed_variant : "#3e4758"
        readonly property color m3onSurface: root.ready ? root.colors.on_surface : "#e2e2e9"
        readonly property color m3onSurfaceVariant: root.ready ? root.colors.on_surface_variant : "#c4c6cf"
        readonly property color m3onTertiary: root.ready ? root.colors.on_tertiary : "#3e2845"
        readonly property color m3onTertiaryContainer: root.ready ? root.colors.on_tertiary_container : "#f9d8fd"
        readonly property color m3onTertiaryFixed: root.ready ? root.colors.on_tertiary_fixed : "#28132f"
        readonly property color m3onTertiaryFixedVariant: root.ready ? root.colors.on_tertiary_fixed_variant : "#563e5c"
        readonly property color m3outline: root.ready ? root.colors.outline : "#8e9099"
        readonly property color m3outlineVariant: root.ready ? root.colors.outline_variant : "#44474e"
        readonly property color m3primary: root.ready ? root.colors.primary : "#a9c7ff"
        readonly property color m3primaryContainer: root.ready ? root.colors.primary_container : "#264777"
        readonly property color m3primaryFixed: root.ready ? root.colors.primary_fixed : "#d6e3ff"
        readonly property color m3primaryFixedDim: root.ready ? root.colors.primary_fixed_dim : "#a9c7ff"
        readonly property color m3scrim: root.ready ? root.colors.scrim : "#000000"
        readonly property color m3secondary: root.ready ? root.colors.secondary : "#bdc7dc"
        readonly property color m3secondaryContainer: root.ready ? root.colors.secondary_container : "#3e4758"
        readonly property color m3secondaryFixed: root.ready ? root.colors.secondary_fixed : "#d9e3f9"
        readonly property color m3secondaryFixedDim: root.ready ? root.colors.secondary_fixed_dim : "#bdc7dc"
        readonly property color m3shadow: root.ready ? root.colors.shadow : "#000000"
        readonly property color m3surface: root.ready ? root.colors.surface : "#111318"
        readonly property color m3surfaceBright: root.ready ? root.colors.surface_bright : "#37393e"
        readonly property color m3surfaceContainer: root.ready ? root.colors.surface_container : "#1d2024"
        readonly property color m3surfaceContainerHigh: root.ready ? root.colors.surface_container_high : "#282a2f"
        readonly property color m3surfaceContainerHighest: root.ready ? root.colors.surface_container_highest : "#33353a"
        readonly property color m3surfaceContainerLow: root.ready ? root.colors.surface_container_low : "#191c20"
        readonly property color m3surfaceContainerLowest: root.ready ? root.colors.surface_container_lowest : "#0c0e13"
        readonly property color m3surfaceDim: root.ready ? root.colors.surface_dim : "#111318"
        readonly property color m3surfaceTint: root.ready ? root.colors.surface_tint : "#a9c7ff"
        readonly property color m3surfaceVariant: root.ready ? root.colors.surface_variant : "#44474e"
        readonly property color m3tertiary: root.ready ? root.colors.tertiary : "#dcbce1"
        readonly property color m3tertiaryContainer: root.ready ? root.colors.tertiary_container : "#563e5c"
        readonly property color m3tertiaryFixed: root.ready ? root.colors.tertiary_fixed : "#f9d8fd"
        readonly property color m3tertiaryFixedDim: root.ready ? root.colors.tertiary_fixed_dim : "#dcbce1"
    }
}
