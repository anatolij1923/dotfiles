import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.config

Item {
    id: root
    implicitHeight: pills.implicitHeight
    implicitWidth: pills.implicitWidth + 20

    property int minWorkspaces: Config.bar.workspaces.shown
    property int currentWorkspace: Hyprland.activeWsId

    ListModel {
        id: wsModel
    }

    function refreshWorkspaces() {
        const real = Hyprland.workspaces?.values || [];
        const sorted = real.slice().sort((a, b) => a.id - b.id);

        const maxCount = Math.max(minWorkspaces, ...sorted.map(w => w.id));
        const data = [];

        for (let i = 1; i <= maxCount; i++) {
            const ws = sorted.find(w => w.id === i);
            data.push({
                id: i,
                focused: ws ? ws.focused : (currentWorkspace === i),
                name: ws ? ws.name : "",
                empty: ws ? (ws.toplevels?.values.length === 0) : true
            });
        }

        if (wsModel.count !== data.length) {
            wsModel.clear();
            data.forEach(item => wsModel.append(item));
        } else {
            for (let i = 0; i < data.length; i++)
                wsModel.set(i, data[i]);
        }
    }

    Component.onCompleted: refreshWorkspaces()

    Connections {
        target: Hyprland
        function onActiveWsIdChanged() {
            refreshWorkspaces();
        }
        function onWorkspacesChanged() {
            refreshWorkspaces();
        }
        function onToplevelsChanged() {
            refreshWorkspaces();
        }
        function onWindowMoved() {
            refreshWorkspaces();
        }
        function onWorkspaceUpdated() {
            refreshWorkspaces();
        } // общий сигнал из singleton
    }

    RowLayout {
        id: pills
        spacing: 4
        Layout.alignment: Qt.AlignVCenter

        Repeater {
            model: wsModel

            delegate: Rectangle {
                id: pill
                width: focused ? 32 : 16
                height: 16
                radius: 8
                color: focused ? Colors.palette.m3primary : (empty ? Colors.palette.m3surfaceVariant : Colors.palette.m3secondary)
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: width  // чтобы spacing учитывался

                Behavior on width {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
                Behavior on color {
                    CAnim {
                        duration: Appearance.animDuration.expressiveEffectsDuration
                        easing.bezierCurve: Appearance.animCurves.expressiveEffects
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: if (Hyprland.activeWsId !== id)
                        Hyprland.dispatch(`workspace ${id}`)
                }
            }
        }
    }
}
