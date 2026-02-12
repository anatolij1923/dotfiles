pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.common

Singleton {
    id: root

    function init() {
    }
    property bool ready:false

    property var stats: ({})

    FileView {
        path: `${Paths.cache}/quickshell/launcherstats.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            root.ready = true;
            Logger.i("STATS", `Loaded: ${path}`);
        }
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                Logger.w("STATS", `${path} not found. Creating default one`);
                writeAdapter();
            } else {
                Logger.e("STATS", `Failed to load launcherstats.json because ${error}`);
            }
        }

        JsonAdapter {
            id: adapter
            property alias apps: root.stats
        }
    }
}
