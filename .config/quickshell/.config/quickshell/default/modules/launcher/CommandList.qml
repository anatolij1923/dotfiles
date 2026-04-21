pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.common
import qs.widgets

ListView {
    id: root
    required property string search
    property var searchField

    function activate() {
        if (!currentItem)
            return false;

        const data = currentItem.modelData;
        if (data) {
            const action = data.action || data.command;
            if (action && action.length > 0) {
                if (action[0] === "autocomplete" && action.length > 1) {
                    searchField.text = ":" + action[1] + " ";
                    return false;
                } else {
                    Quickshell.execDetached(action);
                    return true;
                }
            }
        }
        return false;
    }

    spacing: Appearance.spacing.sm

    implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing

    preferredHighlightBegin: 0
    preferredHighlightEnd: height

    highlightFollowsCurrentItem: false
    highlightRangeMode: ListView.ApplyRange
    model: Commands.query(search.slice(1))
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
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
        }
    }

    delegate: CommandItem {
        searchField: root.searchField
    }
}
