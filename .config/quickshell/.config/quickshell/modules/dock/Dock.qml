import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.config
import Quickshell.Hyprland
import Quickshell.Wayland

Scope {
    id: root
    property bool pinned: Config.dock.pinnedOnStartup

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: dockRoot

            required property var modelData
            screen: modelData
            visible: !GlobalStates.screenLocked

            // --- НАСТРОЙКИ РАЗМЕРОВ ---
            // Высота всего дока
            property int dockHeight: Config.dock.height
            // Высота полоски, которая торчит снизу для наведения
            property int hoverHeight: Config.dock.hoverRegionHeight || 10

            // Логика показа: Закреплено ИЛИ мышь внутри зоны
            property bool reveal: root.pinned || dockMouseArea.containsMouse || (!ToplevelManager.activeToplevel?.activated)

            anchors {
                bottom: true
                left: true
                right: true
            }
            color: "transparent"

            // Ширина по контенту, высота фиксированная
            implicitWidth: dockBackground.implicitWidth
            implicitHeight: dockHeight

            // Эксклюзивная зона только если закреплен
            exclusiveZone: root.pinned ? implicitHeight : 0

            // !!! ВАЖНО: Маска привязана к MouseArea.
            // Когда MouseArea уезжает вниз, маска уезжает вместе с ней.
            mask: Region {
                item: dockMouseArea
            }

            MouseArea {
                id: dockMouseArea
                height: parent.height

                // Включаем отслеживание наведения
                hoverEnabled: true

                anchors {
                    // Привязываемся к верху окна
                    top: parent.top
                    // Центрируем по горизонтали
                    horizontalCenter: parent.horizontalCenter

                    // !!! ГЛАВНАЯ МАГИЯ ИЗ ПРИМЕРА !!!
                    // Если reveal (показать) -> отступ 0 (док полностью в окне)
                    // Если скрыть -> отступ равен (ВысотаДока - ВысотаПолоски)
                    // Это сдвигает весь MouseArea вниз, оставляя видимым только кусочек сверху.
                    topMargin: dockRoot.reveal ? 0 : (dockRoot.implicitHeight - dockRoot.hoverHeight)
                }

                // Анимация этого сдвига
                Behavior on anchors.topMargin {
                    // Используем стандартную анимацию для проверки (или Anim из qs)
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutExpo
                    }
                }

                // Чтобы ширина MouseArea подстраивалась под контент
                implicitWidth: dockHoverRegion.implicitWidth

                // Контейнер для контента
                Item {
                    id: dockHoverRegion
                    anchors.fill: parent

                    // Пробрасываем ширину содержимого наверх
                    implicitWidth: dockBackground.implicitWidth

                    // Сам визуальный док
                    Item {
                        id: dockBackground

                        // !!! ВАЖНО: Якоря внутри MouseArea
                        // Док растянут на всю высоту MouseArea.
                        // Когда MouseArea едет вниз из-за topMargin, этот Item едет вместе с ним.
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                        }

                        implicitWidth: dockRow.implicitWidth + Appearance.padding.normal * 2

                        // Фон дока
                        Rectangle {
                            anchors.fill: parent
                            color: Colors.palette.m3surfaceContainer
                            border {
                                width: 1
                                color: Colors.palette.m3outlineVariant
                            }
                            radius: Appearance.rounding.large
                        }

                        // Содержимое (иконки)
                        RowLayout {
                            id: dockRow
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 8

                            IconButton {
                                icon: "keep"
                                onClicked: root.pinned = !root.pinned
                                checked: root.pinned
                            }

                            Rectangle {
                                implicitWidth: 32
                                implicitHeight: 32
                                color: "red"
                                radius: 4
                            }
                            Rectangle {
                                implicitWidth: 32
                                implicitHeight: 32
                                color: "green"
                                radius: 4
                            }
                            Rectangle {
                                implicitWidth: 32
                                implicitHeight: 32
                                color: "blue"
                                radius: 4
                            }
                        }
                    }
                }
            }
        }
    }
}
