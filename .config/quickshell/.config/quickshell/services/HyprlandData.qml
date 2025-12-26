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

    readonly property ListModel fullWorkspaces: ListModel {}
    readonly property ListModel overviewWorkspaces: ListModel {}

    readonly property int overviewPageSize: {
        try {
            return Config.overview?.pageSize || 8;
        } catch (e) {
            return 8;
        }
    }

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

            // Умное обновление Бара
            if (fullWorkspaces.count !== data.length) {
                fullWorkspaces.clear();
                data.forEach(item => fullWorkspaces.append(item));
            } else {
                for (let i = 0; i < data.length; i++) {
                    let cur = fullWorkspaces.get(i);
                    // ОБЯЗАТЕЛЬНО проверяем cur.id, чтобы при смене страницы цифры менялись!
                    if (cur.id !== data[i].id || cur.focused !== data[i].focused || cur.occupied !== data[i].occupied || cur.exists !== data[i].exists) {
                        fullWorkspaces.set(i, data[i]);
                    }
                }
            }

            // Оставляем овервью в покое, вызываем твою старую функцию
            root.refreshOverviewWorkspaces(sorted);
            root.workspaceUpdated();
        } catch (e) {
            console.warn("Error refreshing workspaces:", e);
        }
    }

    // --- ТВОЙ ОРИГИНАЛЬНЫЙ OVERVIEW (не трогаем) ---
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

    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: root.refreshWorkspaces()
    }

    Component.onCompleted: refreshWorkspaces()
}
