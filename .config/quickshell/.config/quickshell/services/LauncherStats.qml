pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.common
import qs.config

/**
 * Singleton for tracking application launch statistics (Frecency).
 * Uses FileView to persist data in JSON format.
 */
Singleton {
    id: root

    // Stats data structure: { "app.id": { "count": int, "last": timestamp } }
    property var stats: ({})
    property bool ready: false

    // Path to the stats file in user cache
    readonly property string statsPath: Paths.strip(Paths.cache) + "/quickshell/launcherstats.json"

    FileView {
        id: statsFile
        path: root.statsPath

        onLoaded: {
            try {
                let content = text().trim();
                if (content.length > 0) {
                    root.stats = JSON.parse(content);
                } else {
                    root.stats = {};
                }
                root.ready = true;
                Logger.s("STATS", "Statistics loaded successfully");
            } catch (e) {
                Logger.e("STATS", "Error parsing stats JSON: " + e);
                root.stats = {};
            }
        }

        onLoadFailed: err => {
            if (err === FileViewError.FileNotFound) {
                Logger.w("STATS", "Stats file not found, initializing empty database");
                root.stats = {};
                root.ready = true;
            } else {
                Logger.e("STATS", "Failed to load stats: " + err);
            }
        }

        onSaved: Logger.s("STATS", "Statistics saved to disk")
    }

    // Write debounce: wait 500ms after last change before writing to disk
    Timer {
        id: saveTimer
        interval: 500
        onTriggered: {
            let jsonString = JSON.stringify(root.stats);
            statsFile.setText(jsonString);
        }
    }

    /**
     * Records an app launch.
     * @param appId - The application ID (usually .desktop filename)
     */
    function recordLaunch(appId) {
        if (!Config.launcher.useStatsForApps)
            return;

        if (!appId)
            return;

        let current = root.stats[appId] || {
            count: 0,
            last: 0
        };

        root.stats[appId] = {
            count: (current.count || 0) + 1,
            last: Date.now()
        };

        // Notify QML about object changes
        root.statsChanged();

        saveTimer.restart();

        Logger.i("STATS", `Recorded launch: ${appId} (Total: ${root.stats[appId].count})`);
    }

    /**
     * Calculates Frecency Score.
     * Formula: Frequency / log10(Minutes_Since_Last_Launch + 2)
     */
    function getScore(appId) {
        const data = root.stats[appId];
        if (!data || !data.count)
            return 0;

        const now = Date.now();
        const diffMs = now - (data.last || 0);
        const diffMinutes = diffMs / (1000 * 60);

        // Logarithmic decay: recent launches weigh significantly more
        return data.count / Math.log10(diffMinutes + 2);
    }
}
