pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io

import qs
import qs.common
import qs.services
import qs.widgets

StyledWindow {
    id: root

    required property var manager
    required property var modelData
    screen: modelData
    name: "picker"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    exclusionMode: ExclusionMode.Ignore

    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    property int startX: 0
    property int startY: 0
    property int curX: 0
    property int curY: 0
    property bool isDragging: false
    property bool isResizing: false
    property bool hasSelection: false
    property bool isCapturing: false
    property var hoveredWindow: null

    readonly property int rectX: Math.min(startX, curX)
    readonly property int rectY: Math.min(startY, curY)
    readonly property int rectW: Math.abs(curX - startX)
    readonly property int rectH: Math.abs(curY - startY)

    readonly property color accentColor: Colors.palette.m3primary
    readonly property color scrimColor: Colors.alpha(Colors.palette.m3scrim, 0.3)

    function normalize() {
        let x1 = rectX;
        let y1 = rectY;
        let x2 = x1 + rectW;
        let y2 = y1 + rectH;
        startX = x1;
        curX = x2;
        startY = y1;
        curY = y2;
    }

    readonly property var windows: {
        if (!Hyprland || !Hyprland.toplevels)
            return [];
        const activeId = Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1;
        return Hyprland.toplevels.values.filter(w => w.monitor && w.monitor.name === root.screen.name && w.workspace && w.workspace.id === activeId);
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
                    x: winX,
                    y: winY,
                    w: data.size[0],
                    h: data.size[1]
                };
            }
        }
        return null;
    }

    ScreencopyView {
        id: scView
        anchors.fill: parent
        captureSource: root.screen
        live: false
        focus: true
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape)
                GlobalStates.pickerOpened = false;
            if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && root.hasSelection)
                root.prepareCapture("copy");
        }
    }
    Component.onCompleted: scView.forceActiveFocus()

    Item {
        id: uiCanvas
        anchors.fill: parent
        visible: !root.isCapturing

        // window highlight
        Rectangle {
            visible: !root.isDragging && !root.hasSelection && root.hoveredWindow !== null
            x: root.hoveredWindow ? root.hoveredWindow.x : 0
            y: root.hoveredWindow ? root.hoveredWindow.y : 0
            width: root.hoveredWindow ? root.hoveredWindow.w : 0
            height: root.hoveredWindow ? root.hoveredWindow.h : 0
            color: Colors.alpha(root.accentColor, 0.12)
            border.color: Colors.alpha(root.accentColor, 0.3)
            border.width: 1
        }

        // dim
        Item {
            anchors.fill: parent
            Rectangle {
                anchors.fill: parent
                color: root.scrimColor
                visible: !root.isDragging && !root.hasSelection
            }
            Item {
                anchors.fill: parent
                visible: root.isDragging || root.hasSelection
                Rectangle {
                    x: 0
                    y: 0
                    width: parent.width
                    height: root.rectY
                    color: root.scrimColor
                }
                Rectangle {
                    x: 0
                    y: root.rectY + root.rectH
                    width: parent.width
                    height: parent.height - (root.rectY + root.rectH)
                    color: root.scrimColor
                }
                Rectangle {
                    x: 0
                    y: root.rectY
                    width: root.rectX
                    height: root.rectH
                    color: root.scrimColor
                }
                Rectangle {
                    x: root.rectX + root.rectW
                    y: root.rectY
                    width: parent.width - (root.rectX + root.rectW)
                    height: root.rectH
                    color: root.scrimColor
                }
            }
        }

        // selection
        Item {
            id: selectionArea
            x: root.rectX
            y: root.rectY
            width: root.rectW
            height: root.rectH
            visible: root.isDragging || root.hasSelection

            // path
            Shape {
                anchors.fill: parent
                ShapePath {
                    fillColor: "transparent"
                    strokeColor: Colors.palette.m3secondary
                    strokeWidth: 2
                    strokeStyle: ShapePath.DashLine
                    dashPattern: [5, 5]
                    startX: 0
                    startY: 0
                    PathLine {
                        x: selectionArea.width
                        y: 0
                    }
                    PathLine {
                        x: selectionArea.width
                        y: selectionArea.height
                    }
                    PathLine {
                        x: 0
                        y: selectionArea.height
                    }
                    PathLine {
                        x: 0
                        y: 0
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                visible: root.hasSelection && !root.isDragging
                cursorShape: Qt.SizeAllCursor
                property int lastX
                property int lastY
                onPressed: mouse => {
                    lastX = mouse.x;
                    lastY = mouse.y;
                    root.isResizing = true;
                }
                onPositionChanged: mouse => {
                    let dx = mouse.x - lastX;
                    let dy = mouse.y - lastY;
                    root.startX += dx;
                    root.curX += dx;
                    root.startY += dy;
                    root.curY += dy;
                }
                onReleased: root.isResizing = false
            }

            Item {
                anchors.fill: parent
                visible: root.hasSelection && !root.isDragging
                Handle {
                    edgeX: -1
                    edgeY: -1
                } // TL
                Handle {
                    edgeX: 0
                    edgeY: -1
                } // T
                Handle {
                    edgeX: 1
                    edgeY: -1
                } // TR
                Handle {
                    edgeX: 1
                    edgeY: 0
                } // R
                Handle {
                    edgeX: 1
                    edgeY: 1
                } // BR
                Handle {
                    edgeX: 0
                    edgeY: 1
                } // B
                Handle {
                    edgeX: -1
                    edgeY: 1
                } // BL
                Handle {
                    edgeX: -1
                    edgeY: 0
                } // L
            }
        }

        // toolbar
        Rectangle {
            id: toolbar
            visible: root.hasSelection && !root.isDragging && !root.isResizing
            property int margin: 16

            implicitWidth: toolbarContent.implicitWidth + Appearance.spacing.md * 2
            implicitHeight: toolbarContent.implicitHeight + Appearance.spacing.md * 2

            color: Colors.palette.m3surface
            radius: Appearance.rounding.full
            border.color: Colors.palette.border
            border.width: 1

            x: Math.max(margin, Math.min(root.rectX + (root.rectW / 2) - (width / 2), root.width - width - margin))
            y: {
                let needed = height + margin + 10;
                if (root.height - (root.rectY + root.rectH) > needed)
                    return root.rectY + root.rectH + 10;
                if (root.rectY > needed)
                    return root.rectY - height - 10;
                return root.rectY - height - 10;
            }

            ButtonGroup {
                id: toolbarContent
                anchors.centerIn: parent

                model: [
                    {
                        text: "Copy",
                        value: "copy",
                        icon: "content_copy"
                    },
                    {
                        text: "Save",
                        value: "save",
                        icon: "save_as"
                    },
                    {
                        text: "Edit",
                        value: "edit",
                        icon: "edit"
                    },
                    {
                        text: "OCR",
                        value: "ocr",
                        icon: "dictionary"
                    }
                ]

                currentValue: ""

                onSelected: val => {
                    root.prepareCapture(val);
                }
            }
        }
    }

    component Handle: Rectangle {
        property int edgeX: 0 // -1: left, 0: center, 1: right
        property int edgeY: 0 // -1: top, 0: center, 1: bottom

        width: 12
        height: 12 // Чуть увеличил для удобства
        radius: 6
        color: Colors.palette.m3secondary
        border.color: Colors.palette.m3surface
        border.width: 1

        // Центрирование ручки
        x: (edgeX === -1) ? -width / 2 : (edgeX === 1 ? parent.width - width / 2 : parent.width / 2 - width / 2)
        y: (edgeY === -1) ? -height / 2 : (edgeY === 1 ? parent.height - height / 2 : parent.height / 2 - height / 2)

        MouseArea {
            anchors.fill: parent
            anchors.margins: -4 // Увеличиваем зону клика, чтобы легче попасть
            cursorShape: {
                if (edgeX * edgeY > 0)
                    return Qt.SizeFDiagCursor;
                if (edgeX * edgeY < 0)
                    return Qt.SizeBDiagCursor;
                return edgeX !== 0 ? Qt.SizeHorCursor : Qt.SizeVerCursor;
            }
            onPressed: root.isResizing = true
            onPositionChanged: mouse => {
                // ИСПРАВЛЕНИЕ: mapToItem(uiCanvas, ...) вместо mapToItem(root, ...)
                // uiCanvas - это Item, который заполняет весь экран, его координаты нам и нужны.
                let global = mapToItem(uiCanvas, mouse.x, mouse.y);

                // Меняем координаты start или cur в зависимости от того, какую ручку тянем
                if (edgeX === -1)
                    root.startX = global.x;
                if (edgeX === 1)
                    root.curX = global.x;
                if (edgeY === -1)
                    root.startY = global.y;
                if (edgeY === 1)
                    root.curY = global.y;
            }
            onReleased: {
                root.normalize(); // Выравниваем координаты (start < cur)
                root.isResizing = false;
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        hoverEnabled: true
        cursorShape: Qt.CrossCursor
        onPositionChanged: mouse => {
            if (isDragging) {
                root.curX = mouse.x;
                root.curY = mouse.y;
            } else {
                root.hoveredWindow = root.findWindowAt(mouse.x, mouse.y);
            }
        }
        onPressed: mouse => {
            root.startX = mouse.x;
            root.startY = mouse.y;
            root.curX = mouse.x;
            root.curY = mouse.y;
            root.isDragging = true;
            root.hasSelection = false;
        }
        onReleased: mouse => {
            root.isDragging = false;
            if (root.rectW < 10 && root.rectH < 10 && root.hoveredWindow) {
                root.startX = root.hoveredWindow.x;
                root.startY = root.hoveredWindow.y;
                root.curX = root.startX + root.hoveredWindow.w;
                root.curY = root.startY + root.hoveredWindow.h;
            }
            root.hasSelection = (root.rectW > 5 && root.rectH > 5);
            root.normalize();
        }
    }

    Timer {
        id: captureTimer
        interval: 150
        onTriggered: {
            root.manager.runAction(captureTimer.mode, root.screen, {
                x: root.rectX,
                y: root.rectY,
                w: root.rectW,
                h: root.rectH
            });
            GlobalStates.pickerOpened = false;
        }
        property string mode: ""
    }

    function prepareCapture(mode) {
        root.isCapturing = true;
        captureTimer.mode = mode;
        captureTimer.start();
    }
}
