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

Scope {
    id: root

    Loader {
        id: overviewLoader
        active: GlobalStates.overviewOpened

        sourceComponent: StyledWindow {
            id: overviewRoot

            name: "overview"

            property int dragSourceWorkspace: -1
            property int dragTargetWorkspace: -1

            function hide() {
                GlobalStates.overviewOpened = false;
            }

            HyprlandFocusGrab {
                windows: [overviewRoot]
                active: GlobalStates.overviewOpened
                onCleared: () => {
                    if (!active) {
                        overviewRoot.hide()
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: overviewRoot.hide()
            }

            color: "transparent"
            exclusiveZone: 0
            
            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    overviewRoot.hide();
                }
            }

            Loader {
                active: GlobalStates.overviewOpened
                focus: GlobalStates.overviewOpened

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: Appearance.spacing.xl

                sourceComponent: OverviewContent {
                    id: overviewContent
                    dragSourceWorkspace: overviewRoot.dragSourceWorkspace
                    onDragSourceWorkspaceChanged: overviewRoot.dragSourceWorkspace = dragSourceWorkspace
                    dragTargetWorkspace: overviewRoot.dragTargetWorkspace
                    onDragTargetWorkspaceChanged: overviewRoot.dragTargetWorkspace = dragTargetWorkspace
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

    GlobalShortcut {
        name: "toggleOverview"
        description: "Toggle overview"
        onPressed: {
            GlobalStates.overviewOpened = !GlobalStates.overviewOpened
        }
    }
}
