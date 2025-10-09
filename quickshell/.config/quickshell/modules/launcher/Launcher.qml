pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

Scope {
    id: root
    property string searchingText: ""
    property bool showResults: searchingText != ""

    PanelWindow {
        id: launcherRoot
        visible: GlobalStates.launcherOpened
        anchors {
            top: true
        }
        margins.top: 40
        exclusiveZone: 0

        function hide() {
            GlobalStates.launcherOpened = false;
        }

        color: "transparent"
        width: 600
        height: launcherContent.implicitHeight

        Behavior on height {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutCubic
            }
        }

        HyprlandFocusGrab {
            windows: [launcherRoot]
            active: GlobalStates.launcherOpened
            onCleared: () => {
                launcherRoot.hide();
            }
        }

        Loader {
            id: loader
            active: GlobalStates.launcherOpened
            focus: GlobalStates.launcherOpened // Передаем фокус внутрь при активации

            // Весь наш UI теперь находится внутри этого компонента
            sourceComponent: Component {
                ColumnLayout {
                    id: launcherContent
                    width: 600

                    StyledTextField {
                        id: searchInput
                        Layout.fillWidth: true
                        // focus теперь управляется через Loader
                        focus: true
                        placeholder: "Поиск приложений..."

                        onAccepted: {
                            if (resultsView.count > 0) {
                                // Доступ к модели через ID списка
                                resultsView.model[0].execute();
                                // Доступ к функции родительского окна
                                launcherRoot.hide();
                            }
                        }
                        Keys.onEscapePressed: launcherRoot.hide()

                        Connections {
                            target: GlobalStates
                            function onLauncherOpenedChanged() {
                                if (!GlobalStates.launcherOpened) {
                                    // Сбрасываем текст при закрытии
                                    searchInput.text = "";
                                } else {
                                    // Принудительно фокусируемся при открытии
                                    searchInput.forceActiveFocus();
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: resultsView.implicitHeight
                        color: Colors.surface_container
                        radius: 20
                        visible: searchInput.text.length > 0

                        anchors.top: searchInput.bottom
                        anchors.topMargin: -20
                        z: -1

                        ListView {
                            id: resultsView
                            anchors.fill: parent
                            anchors.topMargin: 20
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            anchors.bottomMargin: 8

                            clip: true
                            implicitHeight: contentHeight
                            model: AppSearch.fuzzyQuery(searchInput.text)
                            spacing: 4

                            // СТАЛО (правильно):
                            delegate: Component {
                                AppItem {
                                    entry: modelData

                                    onClicked: {
                                        modelData.execute();
                                        launcherRoot.hide();
                                    }
                                }
                            }
                        }
                    }
                }
            } // конец sourceComponent
        } // конец Loader
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
