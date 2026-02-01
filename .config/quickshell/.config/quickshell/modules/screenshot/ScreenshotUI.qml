pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import qs
import qs.common
import qs.widgets
import qs.services

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    property string screenshotDir: `${Paths.strip(Paths.pictures)}/Screenshots`

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

    readonly property real screenScale: root.screen.devicePixelRatio || 1.0

    Component.onCompleted: {
        Logger.i("SCREENSHOT", `UI opened on screen ${root.screen.name} (Scale: ${screenScale})`);
    }

    ScreencopyView {
        anchors.fill: parent
        captureSource: root.screen
        live: false
        focus: true

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                Logger.w("SCREENSHOT", "Cancelled by user (Escape)");
                GlobalStates.screenshotOpened = false;
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

    Rectangle {
        id: topDim
        anchors {
            top: parent.top
            bottom: selectionRect.top
            left: parent.left
            right: parent.right
        }
        color: root.overlayColor
        visible: root.showOverlay
    }
    Rectangle {
        id: bottomDim
        anchors {
            top: selectionRect.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        color: root.overlayColor
        visible: root.showOverlay
    }
    Rectangle {
        id: leftDim
        anchors {
            top: selectionRect.top
            bottom: selectionRect.bottom
            left: parent.left
            right: selectionRect.left
        }
        color: root.overlayColor
        visible: root.showOverlay
    }
    Rectangle {
        id: rightDim
        anchors {
            top: selectionRect.top
            bottom: selectionRect.bottom
            left: selectionRect.right
            right: parent.right
        }
        color: root.overlayColor
        visible: root.showOverlay
    }

    MouseArea {
        anchors.fill: parent
        z: 10
        cursorShape: Qt.CrossCursor

        onPressed: mouse => {
            root.startX = mouse.x;
            root.startY = mouse.y;
            root.currentX = mouse.x;
            root.currentY = mouse.y;
            root.dragging = true;
            root.hasSelection = false;
        }

        onPositionChanged: mouse => {
            if (dragging) {
                root.currentX = mouse.x;
                root.currentY = mouse.y;
            }
        }

        onReleased: {
            root.dragging = false;
            if (rectW > 5 && rectH > 5) {
                root.hasSelection = true;
                Logger.i("SCREENSHOT", `Region fixed: ${rectW}x${rectH}`);
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

        anchors.horizontalCenter: selectionRect.horizontalCenter
        anchors.top: selectionRect.bottom
        anchors.topMargin: 10

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
                onClicked: captureAction("copy")
                padding: Appearance.padding.small
            }

            TextIconButton {
                icon: "save_as"
                text: "Save"
                onClicked: captureAction("save")
                padding: Appearance.padding.small
            }

            TextIconButton {
                icon: "edit"
                text: "Edit"
                onClicked: captureAction("edit")
                padding: Appearance.padding.small
            }
        }
    }

    function captureAction(mode) {
        let s = root.screenScale;
        let x = Math.round((root.screen.x + rectX) * s);
        let y = Math.round((root.screen.y + rectY) * s);
        let w = Math.round(rectW * s);
        let h = Math.round(rectH * s);

        let geometry = `${x},${y} ${w}x${h}`;
        let timestamp = Qt.formatDateTime(new Date(), "yyyyMMdd_HHmmss");
        let fileName = `Screenshot_${timestamp}.png`;
        let fullPath = `${screenshotDir}/${fileName}`;

        let cmd = "";
        let prepareDir = `mkdir -p "${screenshotDir}"`;

        switch (mode) {
        case "copy":
            cmd = `${prepareDir} && grim -g "${geometry}" - | wl-copy`;
            break;
        case "save":
            cmd = `${prepareDir} && grim -g "${geometry}" "${fullPath}"`;
            break;
        case "edit":
            cmd = `grim -g "${geometry}" - | satty --filename -`;
            break;
        }

        Logger.i("SCREENSHOT", `Action: ${mode} | Cmd: ${cmd}`);
        Quickshell.execDetached(["sh", "-c", cmd]);

        GlobalStates.screenshotOpened = false;
    }
}
