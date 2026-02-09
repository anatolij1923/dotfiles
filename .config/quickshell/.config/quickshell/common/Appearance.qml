pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    readonly property AnimCurves animCurves: AnimCurves {}
    readonly property AnimDuration animDuration: AnimDuration {}
    readonly property Rounding rounding: Rounding {}
    readonly property Spacing spacing: Spacing {}
    readonly property FontSize fontSize: FontSize {}
    readonly property Sizes sizes: Sizes {}

    component AnimCurves: JsonObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1] // Default, 350ms
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1] // Default, 500ms
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1] // Default, 650ms
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1] // Default, 200ms
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        readonly property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
    }

    component AnimDuration: JsonObject {
        property real scale: 1.0

        readonly property int xs: 100 * scale
        readonly property int sm: 200 * scale
        readonly property int md: 400 * scale
        readonly property int lg: 600 * scale
        readonly property int xl: 1000 * scale
        readonly property int expressiveFastSpatial: 350 * scale
        readonly property int expressiveDefaultSpatial: 500 * scale
        readonly property int expressiveSlowSpatial: 650 * scale
        readonly property int expressiveEffects: 200 * scale
    }

    component Rounding: JsonObject {
        readonly property int none: 0
        readonly property int xs: 4
        readonly property int sm: 8
        readonly property int md: 12
        readonly property int lg: 16
        readonly property int xl: 24
        readonly property int xxl: 32
        readonly property int full: 9999
    }

    component Spacing: JsonObject {
        readonly property int xs: 4
        readonly property int sm: 8
        readonly property int md: 12
        readonly property int lg: 16
        readonly property int xl: 24
        readonly property int xxl: 32
        readonly property int xxxl: 48
    }

    component FontSize: JsonObject {
        property real scale: 1.0
        readonly property int xs: 14 * scale
        readonly property int sm: 16 * scale
        readonly property int md: 18 * scale
        readonly property int lg: 22 * scale
        readonly property int xl: 28 * scale
        readonly property int xxl: 32 * scale
    }

    component Sizes: JsonObject {
        property int osdWidth: 250
        property int quicksettingsWidth: 500
    }
}
