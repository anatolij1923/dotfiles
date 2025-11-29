pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.modules.common
import qs.utils

GridView {
    id: root
    required property string search

    readonly property int columns: 3
    readonly property int maxShown: Config.launcher.wallsShown
    readonly property int rows: Math.ceil(maxShown / columns)
    readonly property string searchQuery: search.startsWith(":wallpaper") ? search.slice(":wallpaper".length).trim() : ""
    readonly property real spacing: Appearance.padding.small
    
    function updateModel() {
        const queryResult = Wallpapers.query(searchQuery);
        const sliced = queryResult.slice(0, maxShown);
        console.log("WallpaperList.qml: updateModel called");
        console.log("WallpaperList.qml: search =", search);
        console.log("WallpaperList.qml: searchQuery =", searchQuery);
        console.log("WallpaperList.qml: queryResult length =", queryResult.length);
        console.log("WallpaperList.qml: sliced length =", sliced.length);
        if (sliced.length > 0) {
            console.log("WallpaperList.qml: First wallpaper in model =", sliced[0]);
        } else {
            console.warn("WallpaperList.qml: No wallpapers in model!");
        }
        wallpaperModel = sliced;
    }
    
    property var wallpaperModel: []
    
    onSearchQueryChanged: {
        console.log("WallpaperList.qml: searchQuery changed, updating model");
        updateModel();
    }
    
    Connections {
        target: Wallpapers
        function onListChanged() {
            console.log("WallpaperList.qml: Wallpapers.list changed, updating model");
            updateModel();
        }
    }
    
    anchors.fill: parent
    
    cellWidth: (width - (columns - 1) * spacing) / columns
    cellHeight: cellWidth * (Config.launcher.sizes.wallHeight / Config.launcher.sizes.wallWidth)
    
    implicitHeight: (cellHeight + spacing) * rows - spacing

    model: wallpaperModel
    currentIndex: 0
    
    onCountChanged: {
        console.log("WallpaperList.qml: Model count changed to", count);
    }
    
    Component.onCompleted: {
        console.log("WallpaperList.qml: Component completed");
        console.log("WallpaperList.qml: columns =", columns, "rows =", rows, "maxShown =", maxShown);
        console.log("WallpaperList.qml: cellWidth =", cellWidth, "cellHeight =", cellHeight);
        updateModel();
        console.log("WallpaperList.qml: Initial model count =", count);
    }
    
    onSearchChanged: {
        console.log("WallpaperList.qml: search changed to", search);
    }

    clip: true

    delegate: WallpaperItem {
        required property var modelData
        wallpaperPath: String(modelData || "")
        width: root.cellWidth
        height: root.cellHeight
        
        Component.onCompleted: {
            console.log("WallpaperList.qml: delegate created, index =", index, "path =", wallpaperPath);
        }
    }

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
