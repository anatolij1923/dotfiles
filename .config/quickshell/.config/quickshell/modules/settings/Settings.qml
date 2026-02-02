import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import qs.services
import qs.common
import qs.widgets
import qs.modules.settings
import qs

Scope {
    id: root

    Loader {
        active: GlobalStates.settingsOpened

        sourceComponent: FloatingWindow {
            id: settingsRoot
            title: "quickshell-settings"
            visible: true

            color: Colors.palette.m3surfaceContainer

            onVisibleChanged: {
                if (!visible) {
                    GlobalStates.settingsOpened = false;
                }
            }

            property int currentPage: 0

            RowLayout {
                anchors.fill: parent
                spacing: 0

                SettingsSidebar {
                    currentPage: settingsRoot.currentPage
                    onPageSelected: settingsRoot.currentPage = page
                    Layout.fillHeight: true
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // Эти отступы создадут ту самую "рамку"
                    Layout.margins: Appearance.padding.normal

                    SettingsPage {
                        anchors.fill: parent
                        currentPage: settingsRoot.currentPage
                    }
                }
            }
        }
    }
    IpcHandler {
        target: "settings"

        function open(): void {
            GlobalStates.settingsOpened = true;
        }
        function close(): void {
            GlobalStates.settingsOpened = false;
        }
        function toggle(): void {
            GlobalStates.settingsOpened = !GlobalStates.settingsOpened;
        }
    }
}
