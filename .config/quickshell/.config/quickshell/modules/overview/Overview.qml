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

    StyledWindow {
        id: overviewRoot

        name: "overview"

        property real screenW: screen.width
        property real screenH: screen.height

        property int columns: 4
        property int rows: 2
        property real gap: Appearance.padding.small
        property real outerPadding: Appearance.padding.large

        property int dragSourceWorkspace: -1
        property int dragTargetWorkspace: -1

        property real cardWidthCalc: (implicitWidth - (outerPadding * 2) - (gap * (columns - 1))) / columns
        property real cardHeightCalc: cardWidthCalc / (screen.width / screen.height)

        function hide() {
            GlobalStates.overviewOpened = false;
        }

        visible: GlobalStates.overviewOpened

        HyprlandFocusGrab {
            windows: [overviewRoot]
            active: GlobalStates.overviewOpened
            onCleared: if (!active)
                overviewRoot.hide()
        }

        color: "transparent"
        exclusiveZone: 0
        anchors.top: true
        margins.top: 10

        implicitWidth: screenW * 0.7
        implicitHeight: (cardHeightCalc * rows) + (outerPadding * 2) + (gap * (rows - 1))

        Loader {
            active: GlobalStates.overviewOpened

            focus: GlobalStates.overviewOpened
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    overviewRoot.hide();
                }
            }

            sourceComponent: OverviewContent {
                screenW: overviewRoot.screenW
                screenH: overviewRoot.screenH
                columns: overviewRoot.columns
                rows: overviewRoot.rows
                gap: overviewRoot.gap
                outerPadding: overviewRoot.outerPadding
                cardWidthCalc: overviewRoot.cardWidthCalc
                cardHeightCalc: overviewRoot.cardHeightCalc
                dragSourceWorkspace: overviewRoot.dragSourceWorkspace
                onDragSourceWorkspaceChanged: overviewRoot.dragSourceWorkspace = dragSourceWorkspace
                dragTargetWorkspace: overviewRoot.dragTargetWorkspace
                onDragTargetWorkspaceChanged: overviewRoot.dragTargetWorkspace = dragTargetWorkspace
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
