pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs
import qs.config
import qs.services
import qs.modules.common

Scope {
    id: root
    property int padding: Appearance.padding.normal
    property int rounding: Appearance.rounding.huge
    property string searchingText: ""

    Loader {
        active: GlobalStates.launcherOpened

        sourceComponent: PanelWindow {
            id: launcherRoot
            property real maxHeight: screen.height * 0.35
            visible: GlobalStates.launcherOpened

            implicitWidth: 450
            implicitHeight: Math.min(launcherRoot.maxHeight, searchWrapper.implicitHeight + listWrapper.implicitHeight + root.padding * 2)
            color: "transparent"

            anchors {
                top: true
            }

            // Behavior on implicitHeight {
            //     // Добавьте анимацию, если необходимо, аналогично референсному Wrapper.qml
            // }
            margins {
                top: Appearance.padding.huge
            }
            exclusiveZone: 0

            function hide() {
                GlobalStates.launcherOpened = false;
                root.searchingText = "";
            }

            HyprlandFocusGrab {
                windows: [launcherRoot]
                active: GlobalStates.launcherOpened
                onCleared: if (!active)
                    launcherRoot.hide()
            }

            Rectangle {
                id: background
                anchors.fill: parent
                color: Colors.palette.m3surface
                radius: root.rounding
            }

            Item {
                id: wrapper
                anchors.fill: parent

                Rectangle {
                    id: searchWrapper

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: root.padding
                    }
                    implicitHeight: Math.max(icon.implicitHeight, searchField.implicitHeight)

                    radius: Appearance.rounding.normal
                    color: Colors.palette.m3surfaceContainer

                    MaterialSymbol {
                        id: icon
                        icon: "search"
                        color: Colors.palette.m3onSurfaceVariant

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: root.padding
                        }
                    }

                    StyledTextField {
                        id: searchField
                        focus: true

                        onAccepted: {}

                        Keys.onEscapePressed: launcherRoot.hide()
                        Keys.onUpPressed: contentList.currentList?.decrementCurrentIndex()
                        Keys.onDownPressed: contentList.currentList?.incrementCurrentIndex()

                        anchors {
                            left: icon.right
                            right: parent.right
                            rightMargin: root.padding
                        }

                        topPadding: Appearance.padding.large
                        bottomPadding: Appearance.padding.large

                        placeholderText: `Search or run commands with ":"`

                        fontSize: 20
                        fontWeight: 400
                        placeholderTextColor: Colors.palette.m3outline

                        onTextChanged: root.searchingText = text
                    }
                }

                Item {
                    id: listWrapper

                    implicitHeight: contentList.height

                    clip: true

                    anchors {
                        top: searchWrapper.bottom
                        left: parent.left
                        right: parent.right
                        // bottom: parent.bottom
                        margins: root.padding
                    }

                    ContentList {
                        id: contentList
                        maxHeight: launcherRoot.maxHeight
                        search: root.searchingText
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            GlobalStates.launcherOpened = !GlobalStates.launcherOpened;
        }
        function open(): void {
            GlobalStates.launcherOpened = true;
        }
        function close(): void {
            GlobalStates.launcherOpened = false;
        }
    }
}
