pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.modules.common
import qs.utils

GridView {
    id: root
    required property string search
    required property real maxHeight

    readonly property int columns: 3
    readonly property int referenceShown: Config.launcher.wallsShown // Используется только для расчета размера ячеек
    readonly property int referenceRows: Math.ceil(referenceShown / columns)
    readonly property string searchQuery: search.startsWith(":wallpaper") ? search.slice(":wallpaper".length).trim() : ""
    readonly property real spacing: Appearance.padding.small

    function updateModel() {
        const queryResult = Wallpapers.query(searchQuery);
        wallpaperModel = queryResult; // Показываем все обои, не ограничиваем
    }

    property var wallpaperModel: []

    onSearchQueryChanged: {
        updateModel();
    }

    Connections {
        target: Wallpapers
        function onListChanged() {
            updateModel();
        }
    }

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    // Размеры ячеек - напрямую из конфига
    cellWidth: Config.launcher.sizes.wallWidth
    cellHeight: Config.launcher.sizes.wallHeight

    // Высота СЕТКИ: wallHeight * количество строк + spacing между строками
    readonly property real referenceHeight: (cellHeight + spacing) * referenceRows - spacing

    // Высота GridView: referenceHeight, но не больше maxHeight
    implicitHeight: Math.min(maxHeight, referenceHeight)

    model: wallpaperModel
    currentIndex: 0

    Component.onCompleted: {
        updateModel();
    }

    clip: true

    delegate: WallpaperItem {
        required property var modelData
        wallpaperPath: String(modelData || "")
        width: root.cellWidth - root.spacing
        height: root.cellHeight - root.spacing

        // Центрирование элемента внутри выделенной ячейки
    }

    ScrollBar.vertical: ScrollBar {}

    highlight: Rectangle {
        color: Colors.palette.m3onSurface
        opacity: 0.1
        radius: Appearance.rounding.normal
        width: root.cellWidth
        height: root.cellHeight

        x: root.currentItem?.x ?? 0
        y: root.currentItem?.y ?? 0

        Behavior on x {
            Anim {
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
        }
        Behavior on y {
            Anim {
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
        }
    }
}
