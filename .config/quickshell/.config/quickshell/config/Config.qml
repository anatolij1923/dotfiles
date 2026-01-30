pragma Singleton
import qs.common
import qs.services
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
    property alias battery: adapter.battery

    Timer {
        id: fileWriteTimer
        interval: 300
        repeat: false
        onTriggered: {
            fileView.writeAdapter();
            Logger.i("CONFIG", "Config saved to disk");
        }
    }

    FileView {
        id: fileView
        path: `${Quickshell.shellDir}/config.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            root.ready = true;
            Logger.i("CONFIG", "Config loaded");
        }
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                Logger.w("CONFIG", "Config file not found. Creating default one");
                writeAdapter();
            } else {
                Logger.e("CONFIG", "Failed to load config because {error}");
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
            property BatteryConfig battery: BatteryConfig {}
        }
    }
}
