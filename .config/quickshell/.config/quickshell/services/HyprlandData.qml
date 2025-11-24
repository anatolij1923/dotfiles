pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.config

Singleton {
    id: root

    signal workspaceUpdated
    signal rawEvent(var event)

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors

    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property int activeWsId: focusedWorkspace ? focusedWorkspace.id : 1

    // Models for bar and overview
    readonly property ListModel fullWorkspaces: ListModel {}
    readonly property ListModel overviewWorkspaces: ListModel {}

    readonly property int overviewPageSize: {
        try {
            return Config.overview?.pageSize || 8;
        } catch (e) {
            return 8;
        }
    }

    // Helper to get workspace object safely
    function getWorkspace(id: int): HyprlandWorkspace {
        try {
            if (!root.workspaces)
                return null;
            return root.workspaces.values.find(ws => ws.id === id) || null;
        } catch (e) {
            return null;
        }
    }

    // Helper to dispatch hyprland commands
    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    // Main logic to refresh bar workspaces
    function refreshWorkspaces() {
        try {
            const real = root.workspaces ? root.workspaces.values : [];
            const sorted = real.slice().sort((a, b) => a.id - b.id);

            let maxId = 0;
            if (sorted.length > 0)
                maxId = sorted[sorted.length - 1].id;

            const showCount = Math.max(Config.bar.workspaces.shown || 5, maxId);
            const data = [];

            for (let i = 1; i <= showCount; i++) {
                const ws = sorted.find(w => w.id === i);

                // Check occupancy based on window count
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

            // Smart update to prevent flickering
            if (fullWorkspaces.count !== data.length) {
                fullWorkspaces.clear();
                data.forEach(item => fullWorkspaces.append(item));
            } else {
                for (let i = 0; i < data.length; i++) {
                    let cur = fullWorkspaces.get(i);
                    if (cur.focused !== data[i].focused || cur.occupied !== data[i].occupied || cur.exists !== data[i].exists) {
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

    // Logic to refresh overview pagination
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

    // Main Hyprland event listeners
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

            const triggers = ["workspace", "createworkspace", "destroyworkspace", "moveworkspace", "focusedmon", "openwindow", "closewindow", "movewindow", "fullscreen", "changefloatingmode", "pin"];

            if (triggers.some(t => n.includes(t))) {
                // Force refresh native objects if needed
                if (n.includes("window"))
                    Hyprland.refreshToplevels();
                if (n.includes("workspace"))
                    Hyprland.refreshWorkspaces();

                root.refreshWorkspaces();
            }
        }
    }

    // Direct listeners for collection changes
    Connections {
        target: Hyprland.workspaces
        function onCountChanged() {
            root.refreshWorkspaces();
        }
    }

    Connections {
        target: Hyprland.toplevels
        function onCountChanged() {
            root.refreshWorkspaces();
        }
    }

    // hack: ts fixing windows not tracked on shell startup
    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: root.refreshWorkspaces()
    }

    Component.onCompleted: refreshWorkspaces()
}
