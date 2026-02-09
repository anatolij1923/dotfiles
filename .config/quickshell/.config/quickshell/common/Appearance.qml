pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property AnimCurves animCurves: AnimCurves {}
    property AnimDuration animDuration: AnimDuration {}
    property Rounding rounding: Rounding {}
    property Padding padding: Padding {}
    property Font font: Font {}
    property Sizes sizes: Sizes {}

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
        property real scale: 1
        property int smaller: 100 * scale
        property int small: 200 * scale
        property int normal: 400 * scale
        property int large: 600 * scale
        property int extraLarge: 1000 * scale
        property int expressiveFastSpatial: 350 * scale
        property int expressiveDefaultSpatial: 500 * scale
        property int expressiveSlowSpatial: 650 * scale
        property int expressiveEffects: 200 * scale
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
    component Padding: JsonObject {
        property int smaller: 4
        property int small: 8
        property int normal: 12
        property int large: 16
        property int larger: 20
        property int huge: 24
    }

    component Font: JsonObject {

        property JsonObject size: JsonObject {
            property int scale: 1
            property int tiny: 14 * scale
            property int small: 16 * scale
            property int normal: 18 * scale
            property int large: 22 * scale
            property int xlarge: 28 * scale
            property int huge: 32 * scale
        }
    }

    component Sizes: JsonObject {
        property int osdWidth: 250
        property int quicksettingsWidth: 500
    }
}
