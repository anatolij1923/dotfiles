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

    required property var manager
    required property var modelData
    screen: modelData
    name: "screenshot"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    exclusionMode: ExclusionMode.Ignore

    color: "transparent"
    anchors {
        top: true
        bottom: true
        right: true
        left: true
    }

    ScreencopyView {
        anchors.fill: parent
        captureSource: root.screen
        live: false
        focus: true

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                GlobalStates.screenshotOpened = false;
            }
            if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && root.hasSelection) {
                root.prepareCapture("copy");
            }
        }
    }

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

    readonly property var windows: {
        if (!Hyprland || !Hyprland.toplevels)
            return [];
        const activeWorkspaceId = Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1;
        return Hyprland.toplevels.values.filter(w => {
            return w.monitor && w.monitor.name === root.screen.name && w.workspace && w.workspace.id === activeWorkspaceId;
        });
    }

    function getSnappedPoint(rawX, rawY) {
        let snapDist = 20;
        let bestX = rawX;
        let bestY = rawY;
        for (let i = 0; i < windows.length; i++) {
            let data = windows[i].lastIpcObject;
            if (!data)
                continue;
            let winX = data.at[0] - root.screen.x;
            let winY = data.at[1] - root.screen.y;
            let winR = winX + data.size[0];
            let winB = winY + data.size[1];
            if (Math.abs(rawX - winX) < snapDist)
                bestX = winX;
            else if (Math.abs(rawX - winR) < snapDist)
                bestX = winR;
            if (Math.abs(rawY - winY) < snapDist)
                bestY = winY;
            else if (Math.abs(rawY - winB) < snapDist)
                bestY = winB;
        }
        return {
            x: bestX,
            y: bestY
        };
    }

    function findWindowAt(mx, my) {
        for (let i = windows.length - 1; i >= 0; i--) {
            let data = windows[i].lastIpcObject;
            if (!data)
                continue;
            let winX = data.at[0] - root.screen.x;
            let winY = data.at[1] - root.screen.y;
            if (mx >= winX && mx <= winX + data.size[0] && my >= winY && my <= winY + data.size[1]) {
                return {
                    x: data.at[0],
                    y: data.at[1],
                    w: data.size[0],
                    h: data.size[1]
                };
            }
        }
        return null;
    }

    Rectangle {
        id: topDim
        color: root.overlayColor
        visible: root.showOverlay
        anchors {
            top: parent.top
            bottom: selectionRect.top
            left: parent.left
            right: parent.right
        }
    }
    Rectangle {
        id: bottomDim
        color: root.overlayColor
        visible: root.showOverlay
        anchors {
            top: selectionRect.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }
    Rectangle {
        id: leftDim
        color: root.overlayColor
        visible: root.showOverlay
        anchors {
            top: selectionRect.top
            bottom: selectionRect.bottom
            left: parent.left
            right: selectionRect.left
        }
    }
    Rectangle {
        id: rightDim
        color: root.overlayColor
        visible: root.showOverlay
        anchors {
            top: selectionRect.top
            bottom: selectionRect.bottom
            left: selectionRect.right
            right: parent.right
        }
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
            if (root.rectW < 10 && root.rectH < 10) {
                let win = root.findWindowAt(mouse.x, mouse.y);
                if (win) {
                    root.startX = win.x - root.screen.x;
                    root.startY = win.y - root.screen.y;
                    root.currentX = root.startX + win.w;
                    root.currentY = root.startY + win.h;
                    root.hasSelection = true;
                    return;
                }
            }
            root.hasSelection = (root.rectW > 5 && root.rectH > 5);
        }
    }

    Rectangle {
        id: selectionRect
        x: root.rectX
        y: root.rectY
        width: root.rectW
        height: root.rectH
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
        property int p: Appearance.padding.normal
        implicitWidth: toolbarContent.implicitWidth + p * 2
        implicitHeight: toolbarContent.implicitHeight + p * 2
        color: Colors.palette.m3surface
        radius: Appearance.rounding.full
        border.color: Colors.palette.m3outlineVariant
        border.width: 1

        anchors.horizontalCenter: selectionRect.horizontalCenter

        y: {
            let targetY = selectionRect.y + selectionRect.height + 10;
            // Flip to top if bottom is blocked
            if (targetY + height + 20 > root.height)
                targetY = selectionRect.y - height - 10;
            // Clamp to screen edges
            return Math.max(20, Math.min(targetY, root.height - height - 20));
        }

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
            TextIconButton {
                icon: "dictionary"
                text: "OCR"
                onClicked: root.prepareCapture("ocr")
                padding: Appearance.padding.small
            }
        }
    }

    Timer {
        id: captureTimer
        interval: 150
        repeat: false
        property string mode: ""
        onTriggered: {
            root.manager.capture(root.screen, {
                x: root.rectX,
                y: root.rectY,
                w: root.rectW,
                h: root.rectH
            }, mode);
            GlobalStates.screenshotOpened = false;
        }
    }

    function prepareCapture(mode) {
        root.hasSelection = false;
        root.dragging = false;
        captureTimer.mode = mode;
        captureTimer.start();
    }
}
