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
    readonly property bool isDarkMode: Config.appearance.darkMode
    readonly property string matugenMode: Config.appearance.darkMode ? "dark" : "light"

    property string schemeType: Config.appearance.theming.schemeType
    property string wallpaperPath: Config.background.wallpaperPath

    readonly property var colors: ready && JSON.parse(colorsFile.text()).colors[isDarkMode ? "dark" : "light"]

    function mix(c1, c2, weight = 0.5) {
        let a = Qt.color(c1);
        let b = Qt.color(c2);
        return Qt.rgba(a.r * (1 - weight) + b.r * weight, a.g * (1 - weight) + b.g * weight, a.b * (1 - weight) + b.b * weight, a.a);
    }

    function getLuma(c) {
        let col = Qt.color(c);
        return (0.299 * col.r + 0.587 * col.g + 0.114 * col.b);
    }

    function alpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a);
    }

    function on(c) {
        return getLuma(c) > 0.6 ? "#000000" : "#ffffff";
    }

    function hover(c) {
        return mix(c, on(c), 0.08);
    }

    function active(c) {
        return mix(c, on(c), 0.12);
    }

    function level(n) {
        const weights = [0, 0.05, 0.08, 0.12, 0.15, 0.2];
        return mix(palette.m3surface, palette.m3primary, weights[n] || 0);
    }

    function switchDarkLightMode() {
        Config.appearance.darkMode = !Config.appearance.darkMode;
        Quickshell.execDetached([`${Quickshell.shellDir}/scripts/switchTheme.sh`]);
        Logger.i("COLORS", `${Quickshell.shellDir}/scripts/switchTheme.sh`);
        generateColors();
    }

    function generateColors() {
        if (wallpaperPath === "")
            return;
        if (Config.ready)
            matugenProc.running = true;
    }

    Process {
        id: matugenProc
        command: ["matugen", "-c", Quickshell.shellPath("matugen/config.toml"), "-m", root.matugenMode, "-t", root.schemeType, "image", root.wallpaperPath]
        onExited: code => {
            if (code === 0)
                Logger.s("COLORS", "Palette updated");
        }
    }

    FileView {
        id: colorsFile
        path: `${Quickshell.shellDir}/colors.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.ready = true
    }

    property MatugenPalette palette: MatugenPalette {}

    component MatugenPalette: QtObject {
        readonly property color m3primary: root.ready ? root.colors.primary : "#a9c7ff"
        readonly property color m3background: root.ready ? root.colors.background : "#111318"
        readonly property color m3surface: root.ready ? root.colors.surface : "#111318"
        readonly property color m3primaryContainer: root.ready ? root.colors.primary_container : "#264777"
        readonly property color m3onPrimaryContainer: root.ready ? root.colors.on_primary_container : "#d6e3ff"
        readonly property color m3surfaceContainer: root.ready ? root.colors.surface_container : "#1d2024"

        readonly property color m3surfaceTinted: root.mix(m3background, m3primary, 0.05)
        readonly property color border: root.alpha(m3surfaceVariant, 0.5)
        readonly property color tintedShadow: root.mix(m3shadow, m3primary, 0.05)

        readonly property color m3error: root.ready ? root.colors.error : "#ffb4ab"
        readonly property color m3errorContainer: root.ready ? root.colors.error_container : "#93000a"
        readonly property color m3inverseOnSurface: root.ready ? root.colors.inverse_on_surface : "#2e3036"
        readonly property color m3inversePrimary: root.ready ? root.colors.inverse_primary : "#405f90"
        readonly property color m3inverseSurface: root.ready ? root.colors.inverse_surface : "#e2e2e9"
        readonly property color m3onBackground: root.ready ? root.colors.on_background : "#e2e2e9"
        readonly property color m3onError: root.ready ? root.colors.on_error : "#690005"
        readonly property color m3onErrorContainer: root.ready ? root.colors.on_error_container : "#ffdad6"
        readonly property color m3onPrimary: root.ready ? root.colors.on_primary : "#08305f"
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
        readonly property color m3primaryFixed: root.ready ? root.colors.primary_fixed : "#d6e3ff"
        readonly property color m3primaryFixedDim: root.ready ? root.colors.primary_fixed_dim : "#a9c7ff"
        readonly property color m3scrim: root.ready ? root.colors.scrim : "#000000"
        readonly property color m3secondary: root.ready ? root.colors.secondary : "#bdc7dc"
        readonly property color m3secondaryContainer: root.ready ? root.colors.secondary_container : "#3e4758"
        readonly property color m3secondaryFixed: root.ready ? root.colors.secondary_fixed : "#d9e3f9"
        readonly property color m3secondaryFixedDim: root.ready ? root.colors.secondary_fixed_dim : "#bdc7dc"
        readonly property color m3shadow: root.ready ? root.colors.shadow : "#000000"
        readonly property color m3surfaceBright: root.ready ? root.colors.surface_bright : "#37393e"
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
