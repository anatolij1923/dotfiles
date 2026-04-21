pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.config

Singleton {
    id: root

    property string locale: Config.system.locale
    property var _data: ({})

    FileView {
        id: fileView
        path: locale ? `${Quickshell.shellDir}/translations/${locale}.json` : ""
        watchChanges: true
        onLoaded: {
            try {
                const raw = fileView.text();
                root._data = raw ? JSON.parse(raw) : {};
            } catch (e) {
                root._data = {};
            }
        }
        onFileChanged: reload()
        onLoadFailed: root._data = {}
    }

    function _get(obj, key) {
        const parts = key.split(".");
        let cur = obj;
        for (const p of parts) {
            cur = cur && cur[p];
        }
        return typeof cur === "string" ? cur : undefined;
    }

    function tr(key) {
        const s = _get(root._data, key);
        return s !== undefined ? s : key;
    }
}
