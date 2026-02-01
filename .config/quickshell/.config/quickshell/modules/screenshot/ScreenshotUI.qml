pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io

import qs
import qs.common
import qs.widgets
import qs.services

StyledWindow {
    id: root

    name: "screenshot"

    required property var modelData
    screen: modelData

    property string screenshotDir: `${Paths.strip(Paths.pictures)}/Screenshots`

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    // Ignore exclusive zones (like bars) to cover the full screen
    exclusionMode: ExclusionMode.Ignore

    color: "transparent"
    anchors {
        top: true
        bottom: true
        right: true
        left: true
    }

    readonly property real screenScale: root.screen.devicePixelRatio || 1.0

    // Filter windows belonging to the current monitor and active workspace
    readonly property var windows: {
        if (!Hyprland || !Hyprland.toplevels) return [];

        const activeWs = Hyprland.focusedWorkspace;
        const activeWorkspaceId = activeWs ? activeWs.id : -1;

        return Hyprland.toplevels.values.filter(w => {
            return w.monitor && 
                   w.monitor.name === root.screen.name && 
                   w.workspace && 
                   w.workspace.id === activeWorkspaceId;
        });
    }

    Component.onCompleted: {
        Logger.i("SCREENSHOT", `Initialized on ${root.screen.name} (Scale: ${screenScale})`);
    }

    ScreencopyView {
        anchors.fill: parent
        captureSource: root.screen
        live: false 
        focus: true

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                Logger.w("SCREENSHOT", "Cancelled");
                GlobalStates.screenshotOpened = false;
            }
        }
    }

    // Selection state
    property int startX: 0
    property int startY: 0
    property int currentX: 0
    property int currentY: 0
    property bool dragging: false
    property bool hasSelection: false

    readonly property int rectX: Math.min(startX, currentX)
    readonly property int rectY: Math.min(startY, currentY)
    readonly property int rectW: Math.abs(currentX - startX)
    readonly property int rectH: Math.abs(currentY - startY)

    readonly property color overlayColor: "#80000000"
    readonly property bool showOverlay: root.dragging || root.hasSelection

    // --- GEOMETRY HELPERS ---

    // Magnets current point to window borders if nearby
    function getSnappedPoint(rawX, rawY) {
        let snapDist = 20;
        let bestX = rawX;
        let bestY = rawY;

        if (windows.length === 0) return { x: rawX, y: rawY };

        for (let i = 0; i < windows.length; i++) {
            let data = windows[i].lastIpcObject; // Raw hyprctl data
            if (!data) continue;

            let winX = data.at[0] - root.screen.x;
            let winY = data.at[1] - root.screen.y;
            let winR = winX + data.size[0];
            let winB = winY + data.size[1];

            if (Math.abs(rawX - winX) < snapDist) bestX = winX;
            else if (Math.abs(rawX - winR) < snapDist) bestX = winR;

            if (Math.abs(rawY - winY) < snapDist) bestY = winY;
            else if (Math.abs(rawY - winB) < snapDist) bestY = winB;
        }
        return { x: bestX, y: bestY };
    }

    // Identifies a window at specific coordinates (for single-click selection)
    function findWindowAt(mx, my) {
        for (let i = windows.length - 1; i >= 0; i--) {
            let data = windows[i].lastIpcObject;
            if (!data) continue;

            let winX = data.at[0] - root.screen.x;
            let winY = data.at[1] - root.screen.y;

            if (mx >= winX && mx <= winX + data.size[0] && 
                my >= winY && my <= winY + data.size[1]) {
                Logger.s("SCREENSHOT", `Window detected: [${data.class}]`);
                return { x: data.at[0], y: data.at[1], w: data.size[0], h: data.size[1] };
            }
        }
        return null;
    }

    // Darkens the screen outside the selection area
    Rectangle {
        id: topDim
        color: root.overlayColor
        visible: root.showOverlay
        anchors { top: parent.top; bottom: selectionRect.top; left: parent.left; right: parent.right }
    }
    Rectangle {
        id: bottomDim
        color: root.overlayColor
        visible: root.showOverlay
        anchors { top: selectionRect.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
    }
    Rectangle {
        id: leftDim
        color: root.overlayColor
        visible: root.showOverlay
        anchors { top: selectionRect.top; bottom: selectionRect.bottom; left: parent.left; right: selectionRect.left }
    }
    Rectangle {
        id: rightDim
        color: root.overlayColor
        visible: root.showOverlay
        anchors { top: selectionRect.top; bottom: selectionRect.bottom; left: selectionRect.right; right: parent.right }
    }

    MouseArea {
        anchors.fill: parent
        z: 10
        cursorShape: Qt.CrossCursor

        onPressed: mouse => {
            let snapped = root.getSnappedPoint(mouse.x, mouse.y);
            root.startX = snapped.x;
            root.startY = snapped.y;
            root.currentX = snapped.x;
            root.currentY = snapped.y;
            root.dragging = true;
            root.hasSelection = false;
        }

        onPositionChanged: mouse => {
            if (dragging) {
                let snapped = root.getSnappedPoint(mouse.x, mouse.y);
                root.currentX = snapped.x;
                root.currentY = snapped.y;
            }
        }

        onReleased: mouse => {
            root.dragging = false;

            // Handle single click (select window automatically)
            if (rectW < 10 && rectH < 10) {
                let winData = root.findWindowAt(mouse.x, mouse.y);
                if (winData) {
                    root.startX = winData.x - root.screen.x;
                    root.startY = winData.y - root.screen.y;
                    root.currentX = root.startX + winData.w;
                    root.currentY = root.startY + winData.h;
                    root.hasSelection = true;
                    return;
                }
            }

            if (rectW > 5 && rectH > 5) {
                root.hasSelection = true;
                Logger.i("SCREENSHOT", `Region fixed: ${rectW}x${rectH}`);
            } else {
                root.hasSelection = false;
            }
        }
    }

    Rectangle {
        id: selectionRect
        x: rectX
        y: rectY
        width: rectW
        height: rectH
        color: "transparent"
        border.color: Colors.palette.m3primary
        border.width: 2
        radius: Appearance.rounding.small
        visible: root.showOverlay
    }

    Rectangle {
        id: toolbar
        z: 15
        visible: root.hasSelection && !root.dragging

        property int padding: Appearance.padding.normal
        implicitWidth: toolbarContent.implicitWidth + padding * 2
        implicitHeight: toolbarContent.implicitHeight + padding * 2

        color: Colors.palette.m3surface
        radius: Appearance.rounding.full
        border.color: Colors.palette.m3outlineVariant
        border.width: 1

        anchors {
            horizontalCenter: selectionRect.horizontalCenter
            top: selectionRect.bottom
            topMargin: 10
        }

        // Adaptive positioning: move toolbar above the selection if bottom edge is reached
        states: [
            State {
                name: "TOP"
                when: (selectionRect.y + selectionRect.height + toolbar.height + 20) > root.height
                AnchorChanges {
                    target: toolbar
                    anchors.top: undefined
                    anchors.bottom: selectionRect.top
                }
                PropertyChanges {
                    target: toolbar
                    anchors.bottomMargin: 10
                }
            }
        ]

        RowLayout {
            id: toolbarContent
            anchors.centerIn: parent
            spacing: 8

            TextIconButton {
                icon: "content_copy"
                text: "Copy"
                onClicked: root.prepareCapture("copy")
                padding: Appearance.padding.small
            }

            TextIconButton {
                icon: "save_as"
                text: "Save"
                onClicked: root.prepareCapture("save")
                padding: Appearance.padding.small
            }

            TextIconButton {
                icon: "edit"
                text: "Edit"
                onClicked: root.prepareCapture("edit")
                padding: Appearance.padding.small
            }
        }
    }


    Timer {
        id: captureTimer
        interval: 150 // Small delay 
        repeat: false
        property string mode: ""
        onTriggered: root.captureAction(mode)
    }

    function prepareCapture(mode) {
        // hide ui before shot
        root.hasSelection = false;
        root.dragging = false;
        captureTimer.mode = mode;
        captureTimer.start();
    }

    function captureAction(mode) {
        const s = root.screenScale;
        const x = Math.round((root.screen.x + rectX) * s);
        const y = Math.round((root.screen.y + rectY) * s);
        const w = Math.round(rectW * s);
        const h = Math.round(rectH * s);

        const geometry = `${x},${y} ${w}x${h}`;
        const timestamp = Qt.formatDateTime(new Date(), "yyyyMMdd_HHmmss");
        const fileName = `Screenshot_${timestamp}.png`;
        const fullPath = `${screenshotDir}/${fileName}`;
        const prepareDir = `mkdir -p "${screenshotDir}"`;

        let cmd = "";

        switch (mode) {
            case "copy":
                cmd = `${prepareDir} && grim -g "${geometry}" - | wl-copy && notify-send -a "shell" "Screenshot" "Copied to clipboard"`;
                break;
            case "save":
                cmd = `${prepareDir} && grim -g "${geometry}" "${fullPath}" && notify-send -a "shell" "Screenshot" "Saved at: ${fullPath}"`;
                break;
            case "edit":
                cmd = `grim -g "${geometry}" - | satty --filename -`;
                break;
        }

        Logger.s("SCREENSHOT", `Action: ${mode.toUpperCase()} | Geo: ${geometry}`);
        Quickshell.execDetached(["sh", "-c", cmd]);

        GlobalStates.screenshotOpened = false;
    }
}
