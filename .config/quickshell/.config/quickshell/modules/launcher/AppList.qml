pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.common

ListView {
    id: root
    required property string search

    function activate() {
        if (currentItem) {
            LauncherStats.recordLaunch(currentItem.modelData.id);
            currentItem.modelData.execute();
            GlobalStates.launcherOpened = false;
        }
    }

    spacing: Appearance.spacing.sm

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
        radius: Appearance.rounding.xl

        y: root.currentItem?.y ?? 0
        implicitWidth: root.width
        implicitHeight: root.currentItem?.implicitHeight ?? 0

        Behavior on y {
            Anim {
                duration: Appearance.animDuration.expressiveEffects
                easing.bezierCurve: Appearance.animCurves.expressiveEffects
            }
        }
    }

    delegate: AppItem {}
}
