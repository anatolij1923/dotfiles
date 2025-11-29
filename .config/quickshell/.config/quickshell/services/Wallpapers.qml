pragma Singleton

import Quickshell
import Quickshell.Io
import qs.utils
import qs.config
import QtQuick

/**
 * Service for loading and managing wallpapers
 */
Singleton {
    id: root

    property string wallpaperDir: `${Paths.pictures}/wallpapers`
    property var list: []
    property string actualCurrent: Config.background.wallpaperPath || ""

    Connections {
        target: Config.background
        function onWallpaperPathChanged() {
            root.actualCurrent = Config.background.wallpaperPath || "";
        }
    }

    function getFilteredList(search: string): var {
        // console.log("Wallpapers.qml: getFilteredList called with search =", search);
        // console.log("Wallpapers.qml: total wallpapers in list =", list.length);

        if (!search || search.length === 0) {
            // console.log("Wallpapers.qml: returning full list, count =", list.length);
            return list;
        }

        const searchLower = search.toLowerCase();
        const filtered = list.filter(path => {
            return path.toLowerCase().includes(searchLower);
        });
        // console.log("Wallpapers.qml: filtered list count =", filtered.length);
        return filtered;
    }

    function query(search: string): var {
        const result = getFilteredList(search);
        // console.log("Wallpapers.qml: query returning", result.length, "items");
        return result;
    }

    // Component.onCompleted: {
    //     console.log("Wallpapers.qml: Service initialized");
    //     console.log("Wallpapers.qml: wallpaperDir =", root.wallpaperDir);
    //     console.log("Wallpapers.qml: actualCurrent =", root.actualCurrent);
    // }

    Process {
        id: findProcess
        workingDirectory: root.wallpaperDir
        command: ["sh", "-c", `find -L ${root.wallpaperDir} -type d -path */.* -prune -o -not -name .* -type f -print 2>/dev/null`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                // console.log("Wallpapers.qml: find command finished, raw output length =", text.length);
                const wallList = text.trim().split('\n').filter(path => path.length > 0);
                root.list = wallList;
                // console.log("Wallpapers.qml: Loaded", wallList.length, "wallpapers");
                // if (wallList.length > 0) {
                //     console.log("Wallpapers.qml: First wallpaper =", wallList[0]);
                //     console.log("Wallpapers.qml: Last wallpaper =", wallList[wallList.length - 1]);
                // } else {
                //     console.warn("Wallpapers.qml: No wallpapers found in", root.wallpaperDir);
                // }
            }
        }
    }

    function setWallpaper(path: string): void {
        Config.background.wallpaperPath = path;
        root.actualCurrent = path;
    }

    function setRandomWallpaper(): void {
        if (root.list.length === 0) {
            // console.warn("Wallpapers.qml: No wallpapers available for random selection");
            return;
        }
        const randomIndex = Math.floor(Math.random() * root.list.length);
        const randomWallpaper = root.list[randomIndex];
        root.setWallpaper(randomWallpaper);
    }
}
