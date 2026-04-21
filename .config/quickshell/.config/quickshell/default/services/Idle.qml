pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs
import qs.common

Singleton {
    id: root

    // property bool toggled: GlobalStates.idleIngibitorToggled
    property alias enabled: idleInhibitor.enabled

    FileView {
        id: state
        path: `${Paths.state}/quickshell/idleInhibitor.json`

        onLoaded: {
            if (text() === "true") {
                root.enabled = true;
            } else {
                root.enabled = false;
            }
        }
        onLoadFailed: err => {
            if (err === FileViewError.FileNotFound) {
                root.enabled = false;
                setText("false");
            }
        }
    }

    Timer {
        id: saveTimer
        interval: 100
        onTriggered: {
            state.setText(root.enabled ? "true" : "false");
        }
    }

    onEnabledChanged: {
        saveTimer.restart();
    }

    function toggle() {
        root.enabled = !root.enabled;
    }

    function init() {
    }

    IdleInhibitor {
        id: idleInhibitor
        enabled: root.enabled
        window: PanelWindow {
            color: "transparent"

            Behavior on color {
                CAnim {}
            }
            implicitWidth: 40
            implicitHeight: 50
            anchors {
                right: true
                bottom: true
            }
            mask: Region {
                item: null
            }
        }
    }
}
