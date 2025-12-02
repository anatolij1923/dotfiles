pragma Singleton
import qs.utils
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool ready: false

    property alias bar: adapter.bar
    property alias time: adapter.time
    property alias osd: adapter.osd
    property alias notification: adapter.notification
    property alias background: adapter.background
    property alias appearance: adapter.appearance
    property alias lock: adapter.lock
    property alias weather: adapter.weather
    property alias launcher: adapter.launcher
    property alias gamemode: adapter.gamemode

    Timer {
        id: fileWriteTimer
        interval: 300
        repeat: false
        onTriggered: {
            fileView.writeAdapter();
            console.info("💾 Config saved to disk.");
        }
    }

    FileView {
        id: fileView
        path: `${Paths.config}/config.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                console.warn("Config not found, creating default one.");
                writeAdapter();
            } else {
                console.error("Failed to load config:", error);
            }
        }

        onAdapterUpdated: {
            fileWriteTimer.restart();
        }

        JsonAdapter {
            id: adapter

            property BarConfig bar: BarConfig {}
            property TimeConfig time: TimeConfig {}
            property OsdConfig osd: OsdConfig {}
            property NotificationConfig notification: NotificationConfig {}
            property BackgroundConfig background: BackgroundConfig {}
            property AppearanceConfig appearance: AppearanceConfig {}
            property LockConfig lock: LockConfig {}
            property WeatherConfig weather: WeatherConfig {}
            property LauncherConfig launcher: LauncherConfig {}
            property GamemodeConfig gamemode: GamemodeConfig {}
        }
    }
}
