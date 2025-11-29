pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.modules.common
import qs.utils

Item {
    id: root
    required property string search
    required property real maxHeight

    readonly property int columns: 3
    readonly property int referenceShown: Config.launcher.wallsShown
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

    // cell sizes
    readonly property real cellWidth: Config.launcher.sizes.wallWidth
    readonly property real cellHeight: Config.launcher.sizes.wallHeight

    // grid height
    readonly property real referenceHeight: (cellHeight + spacing) * referenceRows - spacing

    // gridView height
    readonly property real gridViewHeight: {
        const footerApproxHeight = 40;
        return Math.min(maxHeight - footerApproxHeight - spacing, referenceHeight);
    }

    implicitHeight: gridView.height + spacing + footerLayout.implicitHeight

    GridView {
        id: gridView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: root.gridViewHeight

        cellWidth: root.cellWidth
        cellHeight: root.cellHeight

        model: root.wallpaperModel
        currentIndex: 0

        Component.onCompleted: {
            root.updateModel();
        }

        clip: true

        delegate: WallpaperItem {
            required property var modelData
            wallpaperPath: String(modelData || "")
            width: root.cellWidth - root.spacing
            height: root.cellHeight - root.spacing
        }

        highlight: Rectangle {
            color: Colors.palette.m3onSurface
            opacity: 0.1
            radius: Appearance.rounding.normal
            width: root.cellWidth
            height: root.cellHeight

            x: gridView.currentItem?.x ?? 0
            y: gridView.currentItem?.y ?? 0

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

    RowLayout {
        id: footerLayout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: gridView.bottom
        anchors.topMargin: Appearance.padding.smaller

        StyledText {
            text: `${root.wallpaperModel.length} wallpaper${root.wallpaperModel.length !== 1 ? 's' : ''}`
            color: Colors.palette.m3onSurfaceVariant
            size: 18
        }

        Item {
            Layout.fillWidth: true
        }

        TextButton {
            text: "Random"
            padding: Appearance.padding.normal
            onClicked: {
                Wallpapers.setRandomWallpaper();
            }
        }
    }
}
