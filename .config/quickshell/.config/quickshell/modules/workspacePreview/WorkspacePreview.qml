import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.modules.common
import qs.config

PanelWindow {
    id: root

    // NOTE: Живые превью (ScreencopyView) пока отключены. Сначала показываем
    // геометрию окон в миниатюрах, а Screencopy добавим после отладки макета.

    // --- НАСТРОЙКИ ---
    property int columns: 4
    property int rows: 2
    property real gap: Appearance.padding.normal
    property real outerPadding: Appearance.padding.large

    property real screenW: screen.width
    property real screenH: screen.height

    implicitWidth: screenW * 0.7
    property real cardWidthCalc: (implicitWidth - (outerPadding * 2) - (gap * (columns - 1))) / columns
    property real cardHeightCalc: cardWidthCalc / (screen.width / screen.height)
    implicitHeight: (cardHeightCalc * rows) + (outerPadding * 2) + (gap * (rows - 1))

    anchors.top: true
    margins.top: 10
    color: "transparent"
    exclusiveZone: 0

    Rectangle {
        anchors.fill: parent
        color: Colors.palette.m3surface
        radius: Appearance.rounding.large
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: root.outerPadding
        columns: root.columns
        rows: root.rows
        rowSpacing: root.gap
        columnSpacing: root.gap

        Repeater {
            // Используем отдельную модель для Overview (страница по 4x2)
            model: Hyprland.overviewWorkspaces

            delegate: Rectangle {
                id: wsCard
                Layout.preferredWidth: root.cardWidthCalc
                Layout.preferredHeight: Layout.preferredWidth / wsCard.aspectRatio

                property int currentCardId: model.id

                // Используем хелпер из Синглтона (надежнее)
                property var realWs: Hyprland.getWorkspace(currentCardId)
                Component.onCompleted: {
                    if (!realWs) {
                        console.log("[WorkspacePreview] Workspace", currentCardId, "не найден в Hyprland (exists:", model.exists, ")");
                    } else {
                        const count = realWs.toplevels ? realWs.toplevels.values.length : 0;
                        console.log("[WorkspacePreview] Workspace", currentCardId, "готов, окон:", count);
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

                property real hoverScale: cardHoverHandler.hovered ? 1.02 : 1

                radius: Appearance.rounding.medium
                color: model.focused ? Colors.palette.m3surfaceContainerHigh : Colors.palette.m3surfaceContainer
                border.width: model.focused || cardHoverHandler.hovered ? 2 : 1
                border.color: model.focused ? Colors.palette.m3primary : Colors.palette.m3outline
                scale: hoverScale
                clip: true

                Behavior on scale {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutQuad
                    }
                }

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

                // --- ОКНА ---
                Repeater {
                    // Привязываемся к реальному списку окон текущего воркспейса (UntypedObjectModel)
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

                        // Показываем, если окно принадлежит этому воркспейсу
                        visible: hasData

                        Component.onCompleted: {
                            console.log("[WorkspacePreview] Окно ws", wsCard.currentCardId, "title:", windowTitle, "hasData:", hasData, "ipc:", ipc);
                            if (!hasData) {
                                console.warn("[WorkspacePreview] Нет lastIpcObject для окна", modelData?.title, "ws", wsCard.currentCardId, modelData);
                            }
                        }

                        // --- КООРДИНАТЫ ---
                        x: hasData ? (ipc.at[0] - wsCard.workspaceOffsetX) * wsCard.scaleX : 0
                        y: hasData ? (ipc.at[1] - wsCard.workspaceOffsetY) * wsCard.scaleY : 0
                        width: hasData ? Math.max(4, ipc.size[0] * wsCard.scaleX) : 0
                        height: hasData ? Math.max(4, ipc.size[1] * wsCard.scaleY) : 0

                        // --- 1. ЗАЛИВКА ОКНА (визуальный placeholder) ---
                        Rectangle {
                            anchors.fill: parent
                            radius: 6 * wsCard.scaleFactor
                            color: Colors.palette.m3surfaceVariant
                            opacity: 0.85
                            visible: winContainer.visible
                        }

                        // --- 2. РАМКА ---
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            radius: 4 * wsCard.scaleFactor
                            border.color: Colors.palette.m3primary
                            border.width: 1
                            opacity: 0.55
                        }

                        // --- 3. ИКОНКА ПО ЦЕНТРУ ---
                        Rectangle {
                            anchors.centerIn: parent
                            width: winHoverHandler.hovered ? 40 : 30
                            height: width
                            radius: width / 2
                            color: Colors.palette.m3surface
                            opacity: 0.6
                            visible: winContainer.visible

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                }
                            }

                            MaterialSymbol {
                                anchors.centerIn: parent
                                icon: "deployed_code"
                                size: parent.width * 0.6
                                color: Colors.palette.m3onSurface
                            }
                        }

                        // --- 4. ИНФО-ПАНЕЛЬ С НАЗВАНИЕМ ---
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 2
                            radius: 4
                            color: Colors.palette.m3surface
                            opacity: 0.75
                            visible: winContainer.visible

                            Column {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 2

                                StyledText {
                                    text: winContainer.windowTitle
                                    size: 10
                                    elide: Text.ElideRight
                                    weight: 600
                                }

                                StyledText {
                                    text: winContainer.windowApp
                                    size: 9
                                    opacity: 0.7
                                    elide: Text.ElideRight
                                    visible: windowApp.length > 0
                                }
                            }
                        }

                        StyledTooltip {
                            text: winContainer.windowTitle
                            visible: winHoverHandler.hovered
                        }

                        HoverHandler {
                            id: winHoverHandler
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: Appearance.padding.small
                    spacing: Appearance.padding.small

                    StyledText {
                        text: wsCard.realWs ? wsCard.realWs.name : qsTr("Workspace %1").arg(wsCard.currentCardId)
                        size: 12
                        weight: 600
                    }

                    StyledText {
                        text: qsTr("%1 окна").arg(wsCard.realWs ? wsCard.realWs.toplevels.values.length : 0)
                        opacity: 0.7
                        size: 11
                    }
                }

                HoverHandler {
                    id: cardHoverHandler
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: Hyprland.dispatch("workspace " + wsCard.currentCardId)
                }

                StyledTooltip {
                    text: qsTr("Switch to workspace %1").arg(wsCard.currentCardId)
                    visible: cardHoverHandler.hovered
                }
            }
        }
    }
}
