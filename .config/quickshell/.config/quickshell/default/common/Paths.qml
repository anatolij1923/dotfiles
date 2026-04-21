pragma Singleton
import Quickshell
import QtQuick
import QtCore

Singleton {
    id: root

    readonly property url home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property url state: StandardPaths.standardLocations(StandardPaths.GenericStateLocation)[0]
    readonly property url cache: StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]
    readonly property url config: StandardPaths.standardLocations(StandardPaths.GenericConfigLocation)[0]
    readonly property url pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property url videos: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]
    readonly property url downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]

    function strip(path) {
        if (!path)
            return "";
        let s = path.toString();
        if (s.startsWith("file://"))
            s = s.substring(7);

        return decodeURIComponent(s);
    }

    function asUrl(path) {
        if (!path)
            return "";
        let s = path.toString();
        if (s.startsWith("file://") || s.startsWith("http"))
            return s;
        if (s.startsWith("/"))
            return "file://" + s;

        return "file://" + Quickshell.shellDir + "/" + s;
    }

    // readonly property string home: Quickshell.env("HOME")
    // readonly property string pictures: getPath(StandardPaths.PicturesLocation)
    // readonly property string videos: Quickshell.env("XDG_VIDEOS_DIR") || `${home}/Videos`
    //
    // readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}/caelestia`
    // readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/quickshell`
    // // readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/caelestia`
    // readonly property string cache: `${home}/.cache/quickshell`
    // readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/quickshell`
    // readonly property string scriptsDir: Quickshell.shellPath("scripts")
    //
    // readonly property string imagecache: `${cache}/imagecache`
    // readonly property string notifimagecache: `${imagecache}/notifs`
    // readonly property string recsdir: `${videos}/Recordings`
    // readonly property string libdir: Quickshell.env("CAELESTIA_LIB_DIR") || "/usr/lib/caelestia"
}
