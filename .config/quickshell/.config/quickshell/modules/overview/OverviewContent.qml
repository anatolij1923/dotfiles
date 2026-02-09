import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Wayland
import qs
import qs.services
import qs.common
import qs.widgets
import qs.config

// TODO: add more interactions, e.g. kill app on RMB, focus on it with LMB, not just switch ws

Item {
    id: root

    property real screenW: QsWindow.window?.screen.width || 0
    property real screenH: QsWindow.window?.screen.height || 0
    property int columns: 4
    property int rows: 2
    property real gap: Appearance.spacing.sm
    property real outerPadding: Appearance.spacing.lg

    property int dragSourceWorkspace: -1
    property int dragTargetWorkspace: -1

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    property real cardWidthCalc: (implicitWidth - (outerPadding * 2) - (gap * (columns - 1))) / columns
    property real cardHeightCalc: cardWidthCalc / (screenW / screenH)

    implicitWidth: screenW * 0.8
    implicitHeight: (cardHeightCalc * rows) + (outerPadding * 2) + (gap * (rows - 1))

    Rectangle {
        id: background
        anchors.fill: parent
        color: root.transparent ? Qt.alpha(Colors.palette.m3surface, root.alpha) : Colors.palette.m3surface

        radius: Appearance.rounding.xl
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: root.outerPadding
        columns: root.columns
        rows: root.rows
        rowSpacing: root.gap
        columnSpacing: root.gap
        focus: true

        Keys.onPressed: event => {
            switch (event.key) {
            case Qt.Key_Escape:
                GlobalStates.overviewOpened = false;
                break;
            case Qt.Key_Left:
            case Qt.Key_H:
                Hyprland.dispatch("workspace r-1");
                break;
            case Qt.Key_Right:
            case Qt.Key_L:
                Hyprland.dispatch("workspace r+1");
                break;
            }
        }

        Repeater {
            model: HyprlandData.overviewWorkspaces

            delegate: Rectangle {
                id: wsCard
                Layout.preferredWidth: root.cardWidthCalc
                Layout.preferredHeight: Layout.preferredWidth / wsCard.aspectRatio

                z: root.dragSourceWorkspace === currentCardId ? 100 : 1
                property int currentCardId: model.id

                property var realWs: null
                function syncWorkspace() {
                    realWs = HyprlandData.getWorkspace(currentCardId);
                }
                Component.onCompleted: syncWorkspace()
                Connections {
                    target: HyprlandData
                    function onWorkspaceUpdated() {
                        wsCard.syncWorkspace();
                    }
                }

                property var wsMon: realWs ? realWs.monitor : null
                property real monW: wsMon ? wsMon.width : root.screenW
                property real monH: wsMon ? wsMon.height : root.screenH
                property real aspectRatio: (monW > 0 && monH > 0) ? (monW / monH) : (root.screenW / root.screenH)
                property real scaleX: (monW > 0) ? (width / monW) : 0
                property real scaleY: (monH > 0) ? (height / monH) : 0
                property real scaleFactor: Math.min(scaleX, scaleY)
                property real workspaceOffsetX: wsMon ? wsMon.x : 0
                property real workspaceOffsetY: wsMon ? wsMon.y : 0

                property color baseColor: model.focused ? Colors.palette.m3surfaceContainerHigh : Colors.palette.m3surfaceContainer

                radius: Appearance.rounding.md
                color: root.transparent ? Qt.alpha(baseColor, root.alpha) : baseColor
                border.width: model.focused || cardHoverHandler.hovered ? 2 : 1
                border.color: model.focused ? Colors.palette.m3primary : Colors.palette.m3surfaceContainer

                StyledText {
                    anchors.centerIn: parent
                    text: currentCardId
                    opacity: 0.08
                    size: 48
                    weight: 700
                }

                Repeater {
                    model: wsCard.realWs && wsCard.realWs.toplevels ? wsCard.realWs.toplevels : null
                    onModelChanged: {
                        if (!model && wsCard.realWs) {
                            console.log("[WorkspacePreview] Workspace", wsCard.currentCardId, "имеет toplevels=null");
                        }
                    }

                    delegate: Item {
                        id: winContainer

                        property var ipc: modelData.lastIpcObject
                        property bool hasData: ipc !== undefined && ipc.at !== undefined

                        property bool isSyncing: false

                        property string windowTitle: modelData.title || modelData.appId || "Window"
                        property string windowApp: modelData.class ? modelData.class.toUpperCase() : ""
                        property bool isFloating: hasData && ipc.floating === true

                        property string windowAddress: {
                            let addr = modelData.address || (ipc ? ipc.address : "");
                            if (!addr)
                                return "";
                            return addr.toString().startsWith("0x") ? addr : ("0x" + addr);
                        }

                        property string windowIconSource: {
                            const iconId = modelData.appId || modelData.class || (ipc && ipc.class) || modelData.title || "";
                            try {
                                return Quickshell.iconPath(AppSearch.guessIcon(iconId));
                            } catch (e) {
                                return Quickshell.iconPath(iconId);
                            }
                        }

                        property real offsetX: wsCard.workspaceOffsetX
                        property real offsetY: wsCard.workspaceOffsetY

                        property real computedX: hasData ? (ipc.at[0] - offsetX) * wsCard.scaleX : 0
                        property real computedY: hasData ? (ipc.at[1] - offsetY) * wsCard.scaleY : 0
                        property real computedWidth: hasData ? Math.max(4, ipc.size[0] * wsCard.scaleX) : 0
                        property real computedHeight: hasData ? Math.max(4, ipc.size[1] * wsCard.scaleY) : 0

                        visible: hasData
                        width: computedWidth
                        height: computedHeight

                        z: windowMouseArea.drag.active || isSyncing ? 1000 : (isFloating ? 10 : 1)

                        Drag.active: windowMouseArea.drag.active
                        Drag.source: winContainer
                        Drag.hotSpot.x: width / 2
                        Drag.hotSpot.y: height / 2

                        Binding {
                            target: winContainer
                            property: "x"
                            value: winContainer.computedX
                            when: !windowMouseArea.drag.active && !isSyncing
                        }
                        Binding {
                            target: winContainer
                            property: "y"
                            value: winContainer.computedY
                            when: !windowMouseArea.drag.active && !isSyncing
                        }

                        ClippingRectangle {
                            id: visualCard
                            anchors.fill: parent
                            radius: Appearance.rounding.md
                            color: "transparent"
                            clip: true

                            ScreencopyView {
                                id: preview
                                anchors.fill: parent
                                live: true
                                captureSource: modelData && modelData.wayland ? modelData.wayland : null
                                visible: winContainer.visible
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: "black"
                                opacity: windowMouseArea.containsMouse ? 0.2 : 0.0
                                visible: windowMouseArea.containsMouse

                                Behavior on opacity {
                                    Anim {}
                                }
                            }

                            IconImage {
                                anchors.centerIn: parent
                                implicitSize: windowMouseArea.containsMouse ? 64 : 48
                                source: winContainer.windowIconSource

                                Behavior on implicitSize {
                                    Anim {
                                        duration: Appearance.animDuration.expressiveEffects
                                        easing.bezierCurve: Appearance.animCurves.standard
                                    }
                                }
                            }
                        }
                        StyledTooltip {
                            text: winContainer.windowTitle
                            visible: windowMouseArea.containsMouse && !windowMouseArea.drag.active
                        }
                        MouseArea {
                            id: windowMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            drag.target: winContainer
                            drag.axis: Drag.XAndYAxis

                            property real pressX: 0
                            property real pressY: 0
                            property bool dragging: false

                            onClicked: mouse => {
                                if (mouse.button === Qt.RightButton) {
                                    HyprlandData.dispatch("closewindow address:" + winContainer.windowAddress);
                                } else {
                                    HyprlandData.dispatch("focuswindow address:" + winContainer.windowAddress);
                                }
                            }

                            onPressed: mouse => {
                                pressX = mouse.x;
                                pressY = mouse.y;
                                dragging = false;
                                root.dragSourceWorkspace = wsCard.currentCardId;
                                root.dragTargetWorkspace = wsCard.currentCardId;
                            }

                            onPositionChanged: mouse => {
                                if (!dragging && (Math.abs(mouse.x - pressX) > 5 || Math.abs(mouse.y - pressY) > 5)) {
                                    dragging = true;
                                }
                            }

                            onReleased: handleDragRelease()
                        }

                        function handleDragRelease() {
                            if (!windowMouseArea.dragging) {
                                cleanup();
                                return;
                            }

                            if (!winContainer.windowAddress) {
                                console.warn("[WorkspacePreview] Dragged window without valid address");
                                cleanup();
                                return;
                            }

                            const targetWs = root.dragTargetWorkspace;

                            if (targetWs !== -1 && targetWs !== root.dragSourceWorkspace) {
                                HyprlandData.dispatch(`movetoworkspacesilent ${targetWs},address:${winContainer.windowAddress}`);
                            } else if (winContainer.isFloating && wsCard.scaleX > 0) {
                                winContainer.isSyncing = true;
                                const centerX = winContainer.x + winContainer.width / 2;
                                const centerY = winContainer.y + winContainer.height / 2;
                                const dropX = (centerX / wsCard.scaleX) - (ipc.size[0] / 2) + winContainer.offsetX;
                                const dropY = (centerY / wsCard.scaleY) - (ipc.size[1] / 2) + winContainer.offsetY;

                                HyprlandData.dispatch(`movewindowpixel exact ${Math.round(dropX)} ${Math.round(dropY)},address:${winContainer.windowAddress}`);
                                syncTimer.restart();
                            } else {
                                const relX = (winContainer.x + winContainer.width / 2) / wsCard.width;
                                const relY = (winContainer.y + winContainer.height / 2) / wsCard.height;
                                let direction = "";
                                if (relX < 0.25)
                                    direction = "l";
                                else if (relX > 0.75)
                                    direction = "r";
                                else if (relY < 0.25)
                                    direction = "u";
                                else if (relY > 0.75)
                                    direction = "d";

                                if (direction) {
                                    HyprlandData.dispatch(`movewindow ${direction},address:${winContainer.windowAddress}`);
                                }
                            }

                            cleanup();
                        }

                        function cleanup() {
                            windowMouseArea.dragging = false;
                            root.dragSourceWorkspace = -1;
                            root.dragTargetWorkspace = -1;

                            if (!winContainer.isSyncing) {
                                winContainer.x = winContainer.computedX;
                                winContainer.y = winContainer.computedY;
                            }
                        }
                    }
                }

                HoverHandler {
                    id: cardHoverHandler
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: HyprlandData.dispatch("workspace " + wsCard.currentCardId)
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Appearance.rounding.lg
                    color: Colors.palette.m3primary
                    opacity: root.dragTargetWorkspace === wsCard.currentCardId ? 0.15 : 0
                    visible: opacity > 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                DropArea {
                    anchors.fill: parent
                    enabled: root.dragSourceWorkspace !== -1
                    onEntered: {
                        root.dragTargetWorkspace = wsCard.currentCardId;
                    }
                    onExited: {
                        if (root.dragTargetWorkspace === wsCard.currentCardId)
                            root.dragTargetWorkspace = -1;
                    }
                }
            }
        }
    }
}
