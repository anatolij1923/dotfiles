pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.config

Singleton {
    id: root

    signal workspaceUpdated
    signal rawEvent(var event)

    // Workspace properties
    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors

    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property int activeWsId: focusedWorkspace ? focusedWorkspace.id : 1

    readonly property ListModel fullWorkspaces: ListModel {}
    readonly property ListModel overviewWorkspaces: ListModel {}

    readonly property int overviewPageSize: {
        try {
            return Config.overview?.pageSize || 8;
        } catch (e) {
            return 8;
        }
    }

    // Keyboard layout properties
    property list<string> layoutCodes: []
    property var cachedLayoutCodes: ({})
    property string currentLayoutName: ""
    property string currentLayoutCode: ""
    property var baseLayoutFilePath: "/usr/share/X11/xkb/rules/base.lst"
    property bool needsLayoutRefresh: false

    function getWorkspace(id: int): HyprlandWorkspace {
        try {
            if (!root.workspaces)
                return null;
            return root.workspaces.values.find(ws => ws.id === id) || null;
        } catch (e) {
            return null;
        }
    }

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    // Update the layout code according to the layout name (Hyprland gives the name not the code)
    onCurrentLayoutNameChanged: root.updateLayoutCode()
    function updateLayoutCode() {
        if (cachedLayoutCodes.hasOwnProperty(currentLayoutName)) {
            root.currentLayoutCode = cachedLayoutCodes[currentLayoutName];
        } else {
            getLayoutProc.running = true;
        }
    }

    function refreshWorkspaces() {
        try {
            const real = root.workspaces ? root.workspaces.values : [];
            const sorted = real.slice().sort((a, b) => a.id - b.id);

            const pageSize = Config.bar?.workspaces?.shown || 8;
            const active = Math.max(root.activeWsId, 1);
            const pageIndex = Math.floor((active - 1) / pageSize);
            const startId = pageIndex * pageSize + 1;
            const endId = startId + pageSize;

            const data = [];

            for (let i = startId; i < endId; i++) {
                const ws = sorted.find(w => w.id === i);
                const hasWindows = ws ? (ws.toplevels.values.length > 0) : false;

                data.push({
                    id: i,
                    focused: (root.activeWsId === i),
                    workspaceId: ws ? ws.id : -1,
                    occupied: hasWindows,
                    exists: !!ws,
                    name: ws?.name || String(i)
                });
            }

            if (fullWorkspaces.count !== data.length) {
                fullWorkspaces.clear();
                data.forEach(item => fullWorkspaces.append(item));
            } else {
                for (let i = 0; i < data.length; i++) {
                    let cur = fullWorkspaces.get(i);
                    if (cur.id !== data[i].id || cur.focused !== data[i].focused || cur.occupied !== data[i].occupied || cur.exists !== data[i].exists) {
                        fullWorkspaces.set(i, data[i]);
                    }
                }
            }

            root.refreshOverviewWorkspaces(sorted);
            root.workspaceUpdated();
        } catch (e) {
            console.warn("Error refreshing workspaces:", e);
        }
    }

    function refreshOverviewWorkspaces(sortedList) {
        try {
            const sorted = sortedList || (root.workspaces ? root.workspaces.values.slice().sort((a, b) => a.id - b.id) : []);
            const pageSize = root.overviewPageSize;
            const active = Math.max(root.activeWsId, 1);

            const pageIndex = Math.floor((active - 1) / pageSize);
            const start = pageIndex * pageSize + 1;
            const end = start + pageSize;

            const data = [];
            for (let i = start; i < end; i++) {
                const ws = sorted.find(w => w.id === i);
                const hasWindows = ws ? (ws.toplevels.values.length > 0) : false;

                data.push({
                    id: i,
                    focused: root.activeWsId === i,
                    workspaceId: ws ? ws.id : -1,
                    occupied: hasWindows,
                    exists: !!ws,
                    name: ws?.name || String(i)
                });
            }

            if (overviewWorkspaces.count !== data.length) {
                overviewWorkspaces.clear();
                data.forEach(item => overviewWorkspaces.append(item));
            } else {
                for (let i = 0; i < data.length; i++) {
                    overviewWorkspaces.set(i, data[i]);
                }
            }
        } catch (e) {
            console.warn("Error refreshing overview:", e);
        }
    }

    // Listeners
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            root.refreshWorkspaces();
        }
        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;
            if (!n)
                return;
            root.rawEvent(event);
            const triggers = ["workspace", "createworkspace", "destroyworkspace", "moveworkspace", "focusedmon", "openwindow", "closewindow", "movewindow", "activewindow", "fullscreen", "changefloatingmode", "pin"];
            if (triggers.some(t => n.includes(t))) {
                if (n.includes("window"))
                    Hyprland.refreshToplevels();
                if (n.includes("workspace"))
                    Hyprland.refreshWorkspaces();
                root.refreshWorkspaces();
            }
        }
    }

    // Connections {
    //     target: Hyprland.workspaces
    //     function onCountChanged() {
    //         root.refreshWorkspaces();
    //     }
    // }
    // Connections {
    //     target: Hyprland.toplevels
    //     function onCountChanged() {
    //         root.refreshWorkspaces();
    //     }
    // }

    // Get the layout code from the base.lst file by grabbing the line with the current layout name
    Process {
        id: getLayoutProc
        command: ["cat", root.baseLayoutFilePath]

        stdout: StdioCollector {
            id: layoutCollector

            onStreamFinished: {
                const lines = layoutCollector.text.split("\n");
                const targetDescription = root.currentLayoutName;
                const foundLine = lines.find(line => {
                    // Skip comment lines and empty lines
                    if (!line.trim() || line.trim().startsWith('!'))
                        return false;

                    // Match layout: (whitespace + ) key + whitespace + description
                    const matchLayout = line.match(/^\s*(\S+)\s+(.+)$/);
                    if (matchLayout && matchLayout[2] === targetDescription) {
                        root.cachedLayoutCodes[matchLayout[2]] = matchLayout[1];
                        root.currentLayoutCode = matchLayout[1];
                        return true;
                    }

                    // Match variant: (whitespace + ) variant + whitespace + key + whitespace + description
                    const matchVariant = line.match(/^\s*(\S+)\s+(\S+)\s+(.+)$/);
                    if (matchVariant && matchVariant[3] === targetDescription) {
                        const complexLayout = matchVariant[2] + matchVariant[1];
                        root.cachedLayoutCodes[matchVariant[3]] = complexLayout;
                        root.currentLayoutCode = complexLayout;
                        return true;
                    }
                    
                    return false;
                });
                // console.log("[HyprlandXkb] Found line:", foundLine);
                // console.log("[HyprlandXkb] Layout:", root.currentLayoutName, "| Code:", root.currentLayoutCode);
                // console.log("[HyprlandXkb] Cached layout codes:", JSON.stringify(root.cachedLayoutCodes, null, 2));
            }
        }
    }

    // Find out available layouts and current active layout. Should only be necessary on init
    Process {
        id: fetchLayoutsProc
        running: true
        command: ["hyprctl", "-j", "devices"]

        stdout: StdioCollector {
            id: devicesCollector
            onStreamFinished: {
                const parsedOutput = JSON.parse(devicesCollector.text);
                const hyprlandKeyboard = parsedOutput["keyboards"].find(kb => kb.main === true);
                root.layoutCodes = hyprlandKeyboard["layout"].split(",");
                root.currentLayoutName = hyprlandKeyboard["active_keymap"];
                // console.log("[HyprlandXkb] Fetched | Layouts (multiple: " + (root.layouts.length > 1) + "): "
                //     + root.layouts.join(", ") + " | Active: " + root.currentLayoutName);
            }
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: root.refreshWorkspaces()
    }

    // Add the keyboard layout event connections to the existing Connections component
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            root.refreshWorkspaces();
        }
        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;
            if (!n)
                return;
            root.rawEvent(event);
            const triggers = ["workspace", "createworkspace", "destroyworkspace", "moveworkspace", "focusedmon", "openwindow", "closewindow", "movewindow", "activewindow", "fullscreen", "changefloatingmode", "pin"];
            if (triggers.some(t => n.includes(t))) {
                if (n.includes("window"))
                    Hyprland.refreshToplevels();
                if (n.includes("workspace"))
                    Hyprland.refreshWorkspaces();
                root.refreshWorkspaces();
            }
            
            // Handle keyboard layout events
            if (n === "activelayout") {
                if (root.needsLayoutRefresh) {
                    root.needsLayoutRefresh = false;
                    fetchLayoutsProc.running = true;
                }

                // If there's only one layout, the updated layout is always the same
                if (root.layoutCodes.length <= 1) return;

                // Update when layout might have changed
                const dataString = event.data;
                root.currentLayoutName = dataString.split(",")[1];

                // Update layout for on-screen keyboard (osk)
            } else if (n === "configreloaded") {
                // Mark layout code list to be updated when config is reloaded
                root.needsLayoutRefresh = true;
            }
        }
    }

    Component.onCompleted: refreshWorkspaces()
}
