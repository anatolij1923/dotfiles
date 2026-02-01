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

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    color: "transparent"
    anchors {
        top: true
        bottom: true
        right: true
        left: true
    }

    // Закрытие на Escape

    ScreencopyView {
        anchors.fill: parent
        captureSource: root.screen
        live: false
        focus: true
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape)
                GlobalStates.screenshotOpened = false;
        }
    }

    // --- ЛОГИКА ВЫДЕЛЕНИЯ ---
    property int startX: 0
    property int startY: 0
    property int currentX: 0
    property int currentY: 0
    property bool dragging: false
    property bool hasSelection: false // Фиксируем, что выбор сделан

    readonly property int rectX: Math.min(startX, currentX)
    readonly property int rectY: Math.min(startY, currentY)
    readonly property int rectW: Math.abs(currentX - startX)
    readonly property int rectH: Math.abs(currentY - startY)

    // --- ВИЗУАЛ: ЗАТЕМНЕНИЕ (4 прямоугольника вокруг выбора) ---
    readonly property color overlayColor: "#80000000"

    Rectangle {
        id: topDim
        anchors {
            top: parent.top
            bottom: selectionRect.top
            left: parent.left
            right: parent.right
        }
        color: overlayColor
    }
    Rectangle {
        id: bottomDim
        anchors {
            top: selectionRect.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        color: overlayColor
    }
    Rectangle {
        id: leftDim
        anchors {
            top: selectionRect.top
            bottom: selectionRect.bottom
            left: parent.left
            right: selectionRect.left
        }
        color: overlayColor
    }
    Rectangle {
        id: rightDim
        anchors {
            top: selectionRect.top
            bottom: selectionRect.bottom
            left: selectionRect.right
            right: parent.right
        }
        color: overlayColor
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
            }
        }
    }

    // Рамка выбора
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
        visible: root.dragging || root.hasSelection
    }

    // --- ТУЛБАР ---
    Rectangle {
        id: toolbar
        z: 15
        visible: root.hasSelection && !root.dragging // Показываем только когда выбор готов

        property int padding: Appearance.padding.normal
        implicitWidth: toolbarContent.implicitWidth + padding * 2
        implicitHeight: toolbarContent.implicitHeight + padding * 2

        color: Colors.palette.m3surface
        radius: Appearance.rounding.full
        border.color: Colors.palette.m3outlineVariant
        border.width: 1

        anchors {
            top: selectionRect.bottom
            topMargin: 10
            horizontalCenter: selectionRect.horizontalCenter
        }

        // Если тулбар вылетает за границы экрана снизу - перекидываем его наверх
        states: [
            State {
                when: (toolbar.y + toolbar.height) > root.height
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
        let x = rectX;
        let y = rectY;
        let w = rectW;
        let h = rectH;
        let geometry = `${x},${y} ${w}x${h}`;
        let timestamp = new Date().getTime();
        let path = `/tmp/screenshot_${timestamp}.png`;

        let cmd = "";
        if (mode === "copy") {
            cmd = `grim -g "${geometry}" - | wl-copy`;
        } else if (mode === "save") {
            // Тут можно добавить диалог или просто сохранять в ~/Pictures
            cmd = `grim -g "${geometry}" ~/Pictures/Screenshot_${timestamp}.png`;
        } else if (mode === "edit") {
            cmd = `grim -g "${geometry}" - | satty --filename -`;
        }

        Quickshell.execDetached(["sh", "-c", cmd]);
        GlobalStates.screenshotOpened = false; // Закрываем всё
    }
}
