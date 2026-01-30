pragma Singleton

import Quickshell
import Quickshell.Io
import qs.services
import qs.common

Singleton {
    id: root

    readonly property var layoutMap: {
        "English (US)": "en",
        "Russian": "ru"
    }
    property var layoutNames: []
    property int layoutIndex: 0
    property string currentLayout: {
        if (layoutNames.length === 0 || layoutIndex >= layoutNames.length) {
            return "??";
        }

        const fullName = layoutNames[layoutIndex];
        const shortName = layoutMap[fullName];

        return shortName;
    }

    property var workspaces: []
    property int focusedWorkspaceIdx: -1

    function handleEvent(event) {
        const type = Object.keys(event)[0];
        const data = event[type];

        // Logging
        // Logger.i("NIRI SERVICE", "Processing event: " + type)

        switch (type) {
        case "KeyboardLayoutsChanged":
            root.layoutNames = data.keyboard_layouts.names;
            root.layoutIndex = data.keyboard_layouts.current_idx;
            break;
        case "KeyboardLayoutSwitched":
            root.layoutIndex = data.idx;
            break;
        case "WorkspacesChanged":
            let sortedWs = data.workspaces.sort((a, b) => a.idx - b.idx);
            root.workspaces = sortedWs;

            let fIdx = sortedWs.findIndex(ws => ws.is_focused);
            if (fIdx !== -1) {
                root.focusedWorkspaceIdx = fIdx;
            }
            break;
        case "WorkspaceActivated":
            let aIdx = root.workspaces.findIndex(ws => ws.id === data.id);
            if (aIdx !== -1) {
                root.focusedWorkspaceIdx = aIdx;
            }

            root.workspaces = root.workspaces.map(ws => {
                let newWs = ws;
                newWs.is_focused = (ws.id === data.id);
                newWs.is_active = (ws.id === data.id);
                return newWs;
            });
            break;
        }
    }

    function nextLayout() {
        socket.send({
            "Action": {
                "SwitchLayout": {
                    "layout": "Next"
                }
            }
        });
    }

    function focusWorkspace(idx) {
        socket.send({
            "Action": {
                "FocusWorkspace": {
                    "reference": {
                        "Index": idx
                    }
                }
            }
        });
    }

    ChromaSocket {
        id: socket

        path: WmService.niriSocket
        connected: WmService.isNiri

        onConnectionStateChanged: {
            if (socket.connected) {
                Logger.s("NIRI SERVICE", "Connected to socket");
                send('"EventStream"');
            }
        }

        parser: SplitParser {
            onRead: data => {
                // RAW logs
                // Logger.i("NIRI RAW DATA", data)
                try {
                    const event = JSON.parse(data);
                    root.handleEvent(event);
                } catch (e) {
                    Logger.e("NIRI SERVICE", "Error parsing event: " + e);
                }
            }
        }
    }
}
