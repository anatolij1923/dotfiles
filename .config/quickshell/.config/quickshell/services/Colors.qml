pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.config

Singleton {
    id: root

    property bool isDarkMode: Config.appearance.darkMode
    readonly property var colors: JSON.parse(colorsFile.text()).colors[isDarkMode ? "dark" : "light"]

    readonly property Palette palette: Palette {}

    FileView {
        id: colorsFile

        path: Quickshell.env("HOME") + "/.config/quickshell/colors.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            console.log("colors.json loaded", path);
        }
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
        console.log("[COLORS] Generating material palette");
        matugenProcess.running = true;
        console.log("[COLORS] Palette generation completed");
    }

    Connections {
        target: Config.background

        function onWallpaperPathChanged() {
            // generateColors();
            console.log("fsd");
        }
    }

    Process {
        id: matugenProcess
        command: ["matugen", "image", `${Config.background.wallpaperPath}`]
    }

    component Palette: QtObject {
        readonly property color m3background: root.colors.background
        readonly property color m3error: root.colors.error
        readonly property color m3errorContainer: root.colors.error_container
        readonly property color m3inverseOnSurface: root.colors.inverse_on_surface
        readonly property color m3inversePrimary: root.colors.inverse_primary
        readonly property color m3inverseSurface: root.colors.inverse_surface
        readonly property color m3onBackground: root.colors.on_background
        readonly property color m3onError: root.colors.on_error
        readonly property color m3onErrorContainer: root.colors.on_error_container
        readonly property color m3onPrimary: root.colors.on_primary
        readonly property color m3onPrimaryContainer: root.colors.on_primary_container
        readonly property color m3onPrimaryFixed: root.colors.on_primary_fixed
        readonly property color m3onPrimaryFixedVariant: root.colors.on_primary_fixed_variant
        readonly property color m3onSecondary: root.colors.on_secondary
        readonly property color m3onSecondaryContainer: root.colors.on_secondary_container
        readonly property color m3onSecondaryFixed: root.colors.on_secondary_fixed
        readonly property color m3onSecondaryFixedVariant: root.colors.on_secondary_fixed_variant
        readonly property color m3onSurface: root.colors.on_surface
        readonly property color m3onSurfaceVariant: root.colors.on_surface_variant
        readonly property color m3onTertiary: root.colors.on_tertiary
        readonly property color m3onTertiaryContainer: root.colors.on_tertiary_container
        readonly property color m3onTertiaryFixed: root.colors.on_tertiary_fixed
        readonly property color m3onTertiaryFixedVariant: root.colors.on_tertiary_fixed_variant
        readonly property color m3outline: root.colors.outline
        readonly property color m3outlineVariant: root.colors.outline_variant
        readonly property color m3primary: root.colors.primary
        readonly property color m3primaryContainer: root.colors.primary_container
        readonly property color m3primaryFixed: root.colors.primary_fixed
        readonly property color m3primaryFixedDim: root.colors.primary_fixed_dim
        readonly property color m3scrim: root.colors.scrim
        readonly property color m3secondary: root.colors.secondary
        readonly property color m3secondaryContainer: root.colors.secondary_container
        readonly property color m3secondaryFixed: root.colors.secondary_fixed
        readonly property color m3secondaryFixedDim: root.colors.secondary_fixed_dim
        readonly property color m3shadow: root.colors.shadow
        readonly property color m3surface: root.colors.surface
        readonly property color m3surfaceBright: root.colors.surface_bright
        readonly property color m3surfaceContainer: root.colors.surface_container
        readonly property color m3surfaceContainerHigh: root.colors.surface_container_high
        readonly property color m3surfaceContainerHighest: root.colors.surface_container_highest
        readonly property color m3surfaceContainerLow: root.colors.surface_container_low
        readonly property color m3surfaceContainerLowest: root.colors.surface_container_lowest
        readonly property color m3surfaceDim: root.colors.surface_dim
        readonly property color m3surfaceTint: root.colors.surface_tint
        readonly property color m3surfaceVariant: root.colors.surface_variant
        readonly property color m3tertiary: root.colors.tertiary
        readonly property color m3tertiaryContainer: root.colors.tertiary_container
        readonly property color m3tertiaryFixed: root.colors.tertiary_fixed
        readonly property color m3tertiaryFixedDim: root.colors.tertiary_fixed_dim
    }
}
