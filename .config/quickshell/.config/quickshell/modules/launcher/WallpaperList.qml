pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.modules.common
import qs.utils

ListView {
    id: root
    required property string search

    spacing: Appearance.padding.small

    implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing

    preferredHighlightBegin: 0
    preferredHighlightEnd: height

    highlightFollowsCurrentItem: false
    highlightRangeMode: ListView.ApplyRange
    model: AppSearch.fuzzyQuery(search)
    currentIndex: 0

    highlight: Rectangle {
        color: Colors.palette.m3onSurface
        opacity: 0.1
        radius: Appearance.rounding.normal

        y: root.currentItem?.y ?? 0
        implicitWidth: root.width
        implicitHeight: root.currentItem?.implicitHeight ?? 0

        Behavior on y {
            Anim {
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
        }
    }

    delegate: WallpaperItem {}
}
