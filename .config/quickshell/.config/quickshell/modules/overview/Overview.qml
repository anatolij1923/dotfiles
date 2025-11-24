import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Wayland
import qs
import qs.services
import qs.modules.common
import qs.config

Scope {
    id: root

    property bool opened: GlobalStates.overviewOpened

    PanelWindow {
        id: overviewRoot

        // TODO: add ScreencopyView

        visible: GlobalStates.overviewOpened

        property real alpha: Config.appearance.transparency.alpha
        property bool transparent: Config.appearance.transparency.enabled

        property int columns: 4
        property int rows: 2
        property real gap: Appearance.padding.normal
        property real outerPadding: Appearance.padding.large

        property real screenW: screen.width
        property real screenH: screen.height

        property int dragSourceWorkspace: -1
        property int dragTargetWorkspace: -1

        property real cardWidthCalc: (implicitWidth - (outerPadding * 2) - (gap * (columns - 1))) / columns
        property real cardHeightCalc: cardWidthCalc / (screen.width / screen.height)

        implicitWidth: screenW * 0.7
        implicitHeight: (cardHeightCalc * rows) + (outerPadding * 2) + (gap * (rows - 1))

        anchors.top: true
        margins.top: 10
        color: "transparent"
        exclusiveZone: 0
        WlrLayershell.namespace: "quickshell:overview"

        function hide() {
            GlobalStates.overviewOpened = false;
        }

        HyprlandFocusGrab {
            windows: [overviewRoot]
            active: GlobalStates.overviewOpened
            onCleared: if (!active)
                overviewRoot.hide()
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: overviewRoot.transparent ? Qt.alpha(Colors.palette.m3surface, overviewRoot.alpha) : Colors.palette.m3surface

            radius: Appearance.rounding.large
        }

        GridLayout {
            anchors.fill: parent
            anchors.margins: overviewRoot.outerPadding
            columns: overviewRoot.columns
            rows: overviewRoot.rows
            rowSpacing: overviewRoot.gap
            columnSpacing: overviewRoot.gap

            Repeater {
                model: HyprlandData.overviewWorkspaces

                delegate: Rectangle {
                    id: wsCard
                    Layout.preferredWidth: overviewRoot.cardWidthCalc
                    Layout.preferredHeight: Layout.preferredWidth / wsCard.aspectRatio

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
                    property real monW: wsMon ? wsMon.width : overviewRoot.screenW
                    property real monH: wsMon ? wsMon.height : overviewRoot.screenH
                    property real aspectRatio: (monW > 0 && monH > 0) ? (monW / monH) : (overviewRoot.screenW / root.screenH)
                    property real scaleX: (monW > 0) ? (width / monW) : 0
                    property real scaleY: (monH > 0) ? (height / monH) : 0
                    property real scaleFactor: Math.min(scaleX, scaleY)
                    property real workspaceOffsetX: wsMon ? wsMon.x : 0
                    property real workspaceOffsetY: wsMon ? wsMon.y : 0

                    // property real hoverScale: cardHoverHandler.hovered ? 1.02 : 1
                    property color baseColor: model.focused ? Colors.palette.m3surfaceContainerHigh : Colors.palette.m3surfaceContainer

                    radius: Appearance.rounding.small
                    color: overviewRoot.transparent ? Qt.alpha(baseColor, overviewRoot.alpha) : baseColor
                    border.width: model.focused || cardHoverHandler.hovered ? 2 : 1
                    border.color: model.focused ? Colors.palette.m3primary : Colors.palette.m3outline
                    // scale: hoverScale
                    clip: true

                    // Behavior on scale {
                    //     NumberAnimation {
                    //         duration: 120
                    //         easing.type: Easing.OutQuad
                    //     }
                    // }

                    Behavior on border.width {
                        NumberAnimation {
                            duration: 120
                        }
                    }

                    StyledText {
                        anchors.centerIn: parent
                        text: currentCardId
                        opacity: 0.08
                        size: 32
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
                            property string windowTitle: modelData.title || modelData.appId || qsTr("Window")
                            property string windowApp: modelData.class ? modelData.class.toUpperCase() : ""
                            property bool isFloating: hasData && ipc.floating === true
                            property string windowAddressRaw: {
                                if (modelData.address !== undefined && modelData.address !== null)
                                    return modelData.address;
                                if (ipc && ipc.address !== undefined)
                                    return ipc.address;
                                return "";
                            }
                            property string windowAddress: windowAddressRaw && windowAddressRaw.toString().startsWith("0x") ? windowAddressRaw : ("0x" + windowAddressRaw)
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

                            // Component.onCompleted: {
                            //     console.log("[WorkspacePreview] Window ws", wsCard.currentCardId, "title:", windowTitle, "hasData:", hasData, "ipc:", ipc);
                            //     if (!hasData) {
                            //         console.warn("[WorkspacePreview] No lastIpcObject for window", modelData?.title, "ws", wsCard.currentCardId, modelData);
                            //     }
                            // }

                            width: computedWidth
                            height: computedHeight
                            z: windowMouseArea.drag.active ? 1000 : (isFloating ? 10 : 1)

                            Drag.active: windowMouseArea.drag.active
                            Drag.source: winContainer
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2

                            Binding {
                                id: xBinding
                                target: winContainer
                                property: "x"
                                value: winContainer.computedX
                                when: !windowMouseArea.drag.active
                            }

                            Binding {
                                id: yBinding
                                target: winContainer
                                property: "y"
                                value: winContainer.computedY
                                when: !windowMouseArea.drag.active
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 6 * wsCard.scaleFactor
                                color: Colors.palette.m3surfaceVariant

                                opacity: 0.85
                                visible: winContainer.visible
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                radius: 4 * wsCard.scaleFactor
                                border.color: Colors.palette.m3primary
                                border.width: 1
                                opacity: 0.55
                            }

                            Rectangle {
                                anchors.centerIn: parent
                                width: windowMouseArea.containsMouse ? 40 : 30
                                height: width
                                radius: width / 2
                                color: "transparent"
                                visible: winContainer.visible

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 100
                                    }
                                }

                                IconImage {
                                    anchors.centerIn: parent
                                    width: windowMouseArea.containsMouse ? 64 : 48
                                    height: width
                                    source: winContainer.windowIconSource
                                }
                            }

                            // Rectangle {
                            //     anchors.left: parent.left
                            //     anchors.right: parent.right
                            //     anchors.bottom: parent.bottom
                            //     anchors.margins: 2
                            //     radius: 4
                            //     color: Colors.palette.m3surface
                            //     opacity: 0.75
                            //     visible: winContainer.visible
                            //
                            //     Column {
                            //         anchors.fill: parent
                            //         anchors.margins: 4
                            //         spacing: 2
                            //
                            //         StyledText {
                            //             text: winContainer.windowTitle
                            //             size: 10
                            //             elide: Text.ElideRight
                            //             weight: 600
                            //         }
                            //
                            //         StyledText {
                            //             text: winContainer.windowApp
                            //             size: 9
                            //             opacity: 0.7
                            //             elide: Text.ElideRight
                            //             visible: windowApp.length > 0
                            //         }
                            //     }
                            // }

                            StyledTooltip {
                                text: winContainer.windowTitle
                                visible: windowMouseArea.containsMouse
                            }

                            MouseArea {
                                id: windowMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.PointingHandCursor
                                drag.target: winContainer
                                drag.axis: Drag.XAndYAxis
                                property real pressX: 0
                                property real pressY: 0
                                property bool dragging: false

                                onPressed: function (mouse) {
                                    pressX = mouse.x;
                                    pressY = mouse.y;
                                    dragging = false;
                                    overviewRoot.dragSourceWorkspace = wsCard.currentCardId;
                                    overviewRoot.dragTargetWorkspace = wsCard.currentCardId;
                                }

                                onPositionChanged: function (mouse) {
                                    if (!dragging && (Math.abs(mouse.x - pressX) > 5 || Math.abs(mouse.y - pressY) > 5)) {
                                        dragging = true;
                                    }
                                }

                                onReleased: function () {
                                    if (dragging && winContainer.windowAddressRaw.length > 0) {
                                        const targetWorkspace = overviewRoot.dragTargetWorkspace;
                                        if (targetWorkspace !== -1 && targetWorkspace !== overviewRoot.dragSourceWorkspace) {
                                            console.log("[WorkspacePreview] movetoworkspacesilent", targetWorkspace, winContainer.windowAddress);
                                            HyprlandData.dispatch(`movetoworkspacesilent ${targetWorkspace},address:${winContainer.windowAddress}`);
                                        } else if (targetWorkspace === overviewRoot.dragSourceWorkspace) {
                                            if (winContainer.isFloating && wsCard.scaleX > 0 && wsCard.scaleY > 0) {
                                                const centerX = winContainer.x + winContainer.width / 2;
                                                const centerY = winContainer.y + winContainer.height / 2;
                                                const dropX = (centerX / wsCard.scaleX) - (ipc.size[0] / 2) + winContainer.offsetX;
                                                const dropY = (centerY / wsCard.scaleY) - (ipc.size[1] / 2) + winContainer.offsetY;
                                                console.log("[WorkspacePreview] movewindowpixel", dropX, dropY, winContainer.windowAddress);
                                                HyprlandData.dispatch(`movewindowpixel exact ${Math.round(dropX)} ${Math.round(dropY)},address:${winContainer.windowAddress}`);
                                            } else {
                                                const relX = wsCard.width > 0 ? (winContainer.x + winContainer.width / 2) / wsCard.width : 0.5;
                                                const relY = wsCard.height > 0 ? (winContainer.y + winContainer.height / 2) / wsCard.height : 0.5;
                                                let direction = "";
                                                if (relX < 0.25)
                                                    direction = "l";
                                                else if (relX > 0.75)
                                                    direction = "r";
                                                else if (relY < 0.25)
                                                    direction = "u";
                                                else if (relY > 0.75)
                                                    direction = "d";

                                                const movedEnough = Math.abs(winContainer.x - winContainer.computedX) > 10 || Math.abs(winContainer.y - winContainer.computedY) > 10;
                                                if (direction && movedEnough) {
                                                    console.log("[WorkspacePreview] movewindow", direction, winContainer.windowAddress);
                                                    HyprlandData.dispatch(`movewindow ${direction},address:${winContainer.windowAddress}`);
                                                }
                                            }
                                        }
                                    } else if (dragging && winContainer.windowAddressRaw.length === 0) {
                                        console.warn("[WorkspacePreview] Dragged window without address", winContainer.windowTitle, modelData);
                                    } else if (!dragging) {
                                        HyprlandData.dispatch("workspace " + wsCard.currentCardId);
                                    }

                                    Qt.callLater(function () {
                                        winContainer.x = winContainer.computedX;
                                        winContainer.y = winContainer.computedY;
                                    });

                                    dragging = false;
                                    overviewRoot.dragSourceWorkspace = -1;
                                    overviewRoot.dragTargetWorkspace = -1;
                                }
                            }
                        }
                    }

                    // Row {
                    //     anchors.left: parent.left
                    //     anchors.right: parent.right
                    //     anchors.bottom: parent.bottom
                    //     anchors.margins: Appearance.padding.small
                    //     spacing: Appearance.padding.small
                    //
                    //     StyledText {
                    //         text: wsCard.realWs ? wsCard.realWs.name : qsTr("Workspace %1").arg(wsCard.currentCardId)
                    //         size: 12
                    //         weight: 600
                    //     }
                    //
                    //     StyledText {
                    //         text: qsTr("%1 окн").arg(wsCard.realWs ? wsCard.realWs.toplevels.values.length : 0)
                    //         opacity: 0.7
                    //         size: 11
                    //     }
                    // }

                    HoverHandler {
                        id: cardHoverHandler
                    }

                    TapHandler {
                        acceptedButtons: Qt.LeftButton
                        onTapped: HyprlandData.dispatch("workspace " + wsCard.currentCardId)
                    }

                    // StyledTooltip {
                    //     text: qsTr("Switch to workspace %1").arg(wsCard.currentCardId)
                    //     visible: cardHoverHandler.hovered
                    // }

                    Rectangle {
                        anchors.fill: parent
                        radius: Appearance.rounding.normal
                        color: Colors.palette.m3primary
                        opacity: overviewRoot.dragTargetWorkspace === wsCard.currentCardId ? 0.15 : 0
                        visible: opacity > 0
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 120
                            }
                        }
                    }

                    DropArea {
                        anchors.fill: parent
                        enabled: overviewRoot.dragSourceWorkspace !== -1
                        onEntered: {
                            overviewRoot.dragTargetWorkspace = wsCard.currentCardId;
                        }
                        onExited: {
                            if (overviewRoot.dragTargetWorkspace === wsCard.currentCardId)
                                overviewRoot.dragTargetWorkspace = -1;
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "overview"

        function toggle(): void {
            GlobalStates.overviewOpened = !GlobalStates.overviewOpened;
        }
    }
}
