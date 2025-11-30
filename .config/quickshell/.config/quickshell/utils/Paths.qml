pragma Singleton
import Quickshell
import QtQuick
import QtCore

// From https://github.com/caelestia-dots/shell with modifications.
// License: GPLv3

Singleton {
    id: root

    function getPath(type) {
        const urls = StandardPaths.standardLocations(type);

        if (urls.length === 0)
            return "";

        const url = urls[0];

        return url.toString().replace("file://", "");
    }

    readonly property string home: Quickshell.env("HOME")
    readonly property string pictures: getPath(StandardPaths.PicturesLocation)
    readonly property string videos: Quickshell.env("XDG_VIDEOS_DIR") || `${home}/Videos`

    readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}/caelestia`
    readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/quickshell`
    // readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/caelestia`
    readonly property string cache: `${home}/.cache/quickshell`
    readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/quickshell`
    readonly property string scriptsDir: Quickshell.shellPath("scripts")

    readonly property string imagecache: `${cache}/imagecache`
    readonly property string notifimagecache: `${imagecache}/notifs`
    readonly property string recsdir: `${videos}/Recordings`
    readonly property string libdir: Quickshell.env("CAELESTIA_LIB_DIR") || "/usr/lib/caelestia"
}
