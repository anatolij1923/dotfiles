pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets
import qs.config

Item {
    id: root

    property int emptySize: 12
    property int occupiedSize: 14
    property int focusedWidth: 32
    property int focusedHeight: 16

    property int spacing: Appearance.spacing.xs
    property int borderRadius: Appearance.rounding.full

    implicitWidth: layout.width
    implicitHeight: focusedHeight

    readonly property bool isNiri: WmService.isNiri

    readonly property int currentIndex: {
        if (isNiri)
            return NiriService.focusedWorkspaceIdx;
        const targetId = HyprlandData.activeWsId;
        const model = HyprlandData.fullWorkspaces;
        for (let i = 0; i < model.count; i++) {
            if (model.get(i).id === targetId)
                return i;
        }
        return 0;
    }

    readonly property int wsCount: isNiri ? (NiriService.workspaces ? NiriService.workspaces.length : 0) : HyprlandData.fullWorkspaces.count

    Row {
        id: layout
        height: parent.height
        spacing: root.spacing

        Repeater {
            model: root.wsCount
            delegate: Rectangle {
                id: wsItem
                required property int index

                readonly property bool isFocused: root.currentIndex === index
                readonly property bool isOccupied: {
                    if (root.isNiri) {
                        return NiriService.workspaces[index]?.active_window_id !== null;
                    }
                    const ws = HyprlandData.fullWorkspaces.get(index);
                    return ws ? ws.occupied : false;
                }

                anchors.verticalCenter: parent.verticalCenter

                width: isFocused ? root.focusedWidth : (isOccupied ? root.occupiedSize : root.emptySize)
                height: isFocused ? root.focusedHeight : (isOccupied ? root.occupiedSize : root.emptySize)
                radius: root.borderRadius

                color: {
                    if (isFocused)
                        return Colors.palette.m3primary;
                    if (isOccupied)
                        return Colors.palette.m3secondary;
                    return Colors.mix(Colors.palette.m3surfaceContainer, Colors.palette.m3primary, 0.15);
                }

                Behavior on width {
                    Anim {
                        duration: Appearance.animDuration.expressiveEffects
                        easing.bezierCurve: Appearance.animCurves.expressiveEffects
                    }
                }
                Behavior on height {
                    Anim {
                        duration: Appearance.animDuration.expressiveEffects
                        easing.bezierCurve: Appearance.animCurves.expressiveEffects
                    }
                }
                Behavior on color {
                    CAnim {}
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.switchTo(wsItem.index)
                }
            }
        }
    }

    function switchTo(index) {
        if (index < 0 || index >= wsCount)
            return;
        if (isNiri) {
            NiriService.focusWorkspace(index);
        } else {
            const ws = HyprlandData.fullWorkspaces.get(index);
            if (ws)
                HyprlandData.dispatch(`workspace ${ws.id}`);
        }
    }
}
