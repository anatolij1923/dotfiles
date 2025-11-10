pragma Singleton
import qs.utils
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property alias bar: adapter.bar
    property alias time: adapter.time
    property alias osd: adapter.osd
    property alias notification: adapter.notification
    property alias background: adapter.background
    FileView {
        id: fileView
        path: `${Paths.config}/config.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: console.info("Config loaded")
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                console.warn("Config not found, creating default one.");
                writeAdapter(); // Создаем файл с дефолтными значениями
            } else {
                console.error("Failed to load config:", error);
            }
        }

        JsonAdapter {
            id: adapter

            // --- "Подключаем" наши модули ---
            // Имя свойства (bar) станет ключом в JSON
            // Тип (Bar) - это имя QML-файла (Bar.qml)
            property BarConfig bar: BarConfig {}
            property TimeConfig time: TimeConfig {}
            property OsdConfig osd: OsdConfig {}
            property NotificationConfig notification: NotificationConfig {}
            property BackgroundConfig background: BackgroundConfig {}
        }
    }
}
