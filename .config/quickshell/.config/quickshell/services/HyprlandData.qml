pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.config

Singleton {
    id: root

    signal workspaceUpdated
    signal rawEvent(var event)

    // Проксируем нативные свойства (это быстро, работает через C++)
    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors

    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property int activeWsId: focusedWorkspace ? focusedWorkspace.id : 1

    // Эта модель нужна для твоей панели (рисовать кружочки 1-5, даже если они пустые)
    readonly property ListModel fullWorkspaces: ListModel {}
    readonly property ListModel overviewWorkspaces: ListModel {}
    readonly property int overviewPageSize: {
        try {
            return Config.overview?.pageSize || 8;
        } catch (e) {
            return 8;
        }
    }

    // Хелпер для получения воркспейса (используй в Overview)
    function getWorkspace(id: int): HyprlandWorkspace {
        try {
            if (!root.workspaces)
                return null;
            return root.workspaces.values.find(ws => ws.id === id) || null;
        } catch (e) {
            return null;
        }
    }

    function refreshWorkspaces() {
        try {
            const real = root.workspaces ? root.workspaces.values : [];
            const sorted = real.slice().sort((a, b) => a.id - b.id);

            // Определяем макс. ID воркспейса
            let maxId = 0;
            if (sorted.length > 0)
                maxId = sorted[sorted.length - 1].id;

            // Берем либо из конфига, либо минимум 5 (чтобы панель не была пустой)
            const showCount = Math.max(Config.bar.workspaces.shown || 5, maxId);

            const data = [];
            for (let i = 1; i <= showCount; i++) {
                const ws = sorted.find(w => w.id === i);

                // ГЛАВНЫЙ ФИКС ДЛЯ ПАНЕЛИ:
                // Проверяем occupied не только по наличию ws, но и по списку окон внутри
                const hasWindows = ws ? (ws.toplevels.values.length > 0) : false;
                const isFocused = (root.activeWsId === i);

                data.push({
                    id: i,
                    focused: isFocused,
                    workspaceId: ws ? ws.id : -1,
                    occupied: hasWindows // Это свойство нужно твоему виджету
                    ,
                    exists: !!ws,
                    name: ws?.name || String(i)
                });
            }

            // Умное обновление (чтобы не моргало)
            if (fullWorkspaces.count !== data.length) {
                fullWorkspaces.clear();
                data.forEach(item => fullWorkspaces.append(item));
            } else {
                for (let i = 0; i < data.length; i++) {
                    let cur = fullWorkspaces.get(i);
                    // Обновляем только если что-то реально изменилось
                    if (cur.focused !== data[i].focused || cur.occupied !== data[i].occupied || cur.exists !== data[i].exists) {
                        fullWorkspaces.set(i, data[i]);
                    }
                }
            }

            root.refreshOverviewWorkspaces(sorted);
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
            console.warn("Error refreshing overview workspaces:", e);
        }
    }

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    // Обновляем при старте
    Component.onCompleted: refreshWorkspaces()

    Connections {
        target: Hyprland

        // ФИКС РАССИНХРОНА ПРИ СТАРТЕ:
        // Слушаем изменение активного воркспейса
        function onFocusedWorkspaceChanged() {
            root.refreshWorkspaces();
        }
        // Слушаем изменение списка воркспейсов
        function onWorkspacesChanged() {
            root.refreshWorkspaces();
        }
        // Слушаем изменение окон (чтобы точки на панели загорались/гасли)
        function onToplevelsChanged() {
            root.refreshWorkspaces();
        }

        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;
            // Правильная проверка v2 от "того чела"
            if (!n || !n.endsWith("v2"))
                return;

            root.rawEvent(event);

            const triggers = ["workspace", "moveworkspace", "createworkspace", "destroyworkspace", "movewindow", "openwindow", "closewindow", "fullscreen"];

            if (triggers.some(t => n.includes(t))) {
                // Пинаем нативные биндинги обновиться
                Hyprland.refreshWorkspaces();
                Hyprland.refreshToplevels();

                // И обновляем нашу модель
                root.refreshWorkspaces();
                root.workspaceUpdated();
                root.refreshOverviewWorkspaces();
            }
        }
    }
}
