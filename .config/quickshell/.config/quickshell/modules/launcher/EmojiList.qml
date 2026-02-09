// modules/launcher/EmojiList.qml
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.common
import qs.widgets

ListView {
    id: root
    required property string search

    function activate() {
        if (currentItem && typeof currentItem.execute === "function") {
            currentItem.execute();
            return true;
        }
        return false;
    }

    spacing: Appearance.padding.small

    implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing

    model: EmojisService.query(search)
    currentIndex: 0

    clip: true
    preferredHighlightBegin: 0
    preferredHighlightEnd: height
    highlightFollowsCurrentItem: false
    highlightRangeMode: ListView.ApplyRange

    highlight: Rectangle {
        color: Colors.palette.m3onSurface
        opacity: 0.1
        radius: Appearance.rounding.xl

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

    delegate: EmojiItem {
        property bool isCurrent: ListView.isCurrentItem
    }

    onCountChanged: currentIndex = 0
}
