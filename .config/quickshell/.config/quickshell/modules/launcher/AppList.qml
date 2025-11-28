import Quickshell
import QtQuick
import qs.config
import qs.services
import qs.modules.launcher.items

ListView {
    id: root
    required property string search

    spacing: Appearance.padding.small

    implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing

    // preferredHighlightBegin: 0
    // preferredHighlightEnd: height

    model: AppSearch.fuzzyQuery(search)

    delegate: AppItem {}
}
