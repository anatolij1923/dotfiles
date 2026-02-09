import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets
import qs.config

Item {
    id: root

    readonly property bool isNiri: WmService.isNiri
    readonly property var wsModel: isNiri ? NiriService.workspaces : HyprlandData.fullWorkspaces
    readonly property int wsCount: isNiri ? (wsModel ? wsModel.length : 0) : (wsModel ? wsModel.count : 0)
    property int currentIndex: isNiri ? NiriService.focusedWorkspaceIdx : 0

    function updateIndex() {
        if (!wsModel)
            return;
        if (root.isNiri)
            currentIndex = NiriService.focusedWorkspaceIdx;
        else {
            for (let i = 0; i < HyprlandData.fullWorkspaces.count; i++) {
                if (HyprlandData.fullWorkspaces.get(i).id === HyprlandData.activeWsId) {
                    currentIndex = i;
                    break;
                }
            }
        }
    }

    readonly property int inactiveSize: 14
    readonly property int itemHeight: 14
    readonly property int activeWidth: inactiveSize * 2
    readonly property int spacing: Appearance.spacing.xs

    implicitWidth: layout.width

    Row {
        id: layout
        anchors.centerIn: parent
        spacing: root.spacing

        Repeater {
            model: root.wsCount
            delegate: Rectangle {
                id: wsItem

                readonly property bool isFocused: root.currentIndex === index
                readonly property bool occupied: root.isNiri ? (wsModel[index] && wsModel[index].active_window_id !== null) : (wsModel.get(index) && wsModel.get(index).occupied)

                width: isFocused ? root.activeWidth : root.inactiveSize
                height: root.itemHeight
                radius: height / 2

                color: isFocused ? Colors.palette.m3primary : (occupied ? Colors.palette.m3secondary : Colors.mix(Colors.palette.m3surface, Colors.palette.m3primary, 0.25))

                Behavior on width {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }

                Behavior on color {
                    CAnim {}
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.isNiri)
                            NiriService.focusWorkspace(index);
                        else
                            HyprlandData.dispatch(`workspace ${index + 1}`);
                    }
                }
            }
        }
    }

    Connections {
        target: isNiri ? NiriService : HyprlandData
        function onWorkspaceUpdated() {
            root.updateIndex();
        }
        function onWorkspacesChanged() {
            root.updateIndex();
        }
        function onFocusedWorkspaceIdxChanged() {
            root.updateIndex();
        }
    }
    Component.onCompleted: updateIndex()

    WheelHandler {
        onWheel: event => {
            let direction = event.angleDelta.y < 0 ? 1 : -1;
            if (root.isNiri)
                NiriService.focusWorkspace(root.currentIndex + direction);
            else
                HyprlandData.dispatch(`workspace ${direction > 0 ? "r+1" : "r-1"}`);
        }
    }
}
