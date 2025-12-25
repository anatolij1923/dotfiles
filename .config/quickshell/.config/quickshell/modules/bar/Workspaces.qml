import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.config

Rectangle {
    id: root

    // --- Настройки из Figma ---
    readonly property int itemSize: 36
    readonly property int activeSize: 32
    readonly property int spacing: 4

    implicitHeight: root.itemSize + 8
    implicitWidth: (HyprlandData.fullWorkspaces.count * (root.itemSize + root.spacing)) + root.spacing

    radius: height / 2
    color: Colors.palette.m3surfaceContainer

    property int currentIndex: 0
    function updateIndex() {
        for (let i = 0; i < HyprlandData.fullWorkspaces.count; i++) {
            if (HyprlandData.fullWorkspaces.get(i).id === HyprlandData.activeWsId) {
                currentIndex = i;
                break;
            }
        }
    }

    function isOccupied(index) {
        if (index < 0 || index >= HyprlandData.fullWorkspaces.count)
            return false;
        return HyprlandData.fullWorkspaces.get(index).occupied;
    }

    Connections {
        target: HyprlandData
        function onWorkspaceUpdated() {
            root.updateIndex();
        }
    }
    Component.onCompleted: updateIndex()

    // 1. СЛОЙ ПОДЛОЖЕК
    Row {
        id: backgroundRow
        anchors.centerIn: parent
        spacing: root.spacing
        z: 1

        Repeater {
            model: HyprlandData.fullWorkspaces
            delegate: Item {
                width: root.itemSize
                height: root.itemSize

                // Мостик (рисуем его ПЕРВЫМ, чтобы он был под кругом текущего элемента)
                Rectangle {
                    id: bridge
                    // Ширина мостика = размер одного элемента + отступ между ними
                    // Это позволяет ему дотянуться от центра текущего до центра следующего
                    width: root.itemSize + root.spacing
                    height: parent.height
                    x: parent.width / 2 // Начинаем из центра текущего круга

                    color: Colors.palette.m3secondaryContainer

                    // Мостик виден, только если ТЕКУЩИЙ и СЛЕДУЮЩИЙ заняты
                    visible: root.isOccupied(index) && root.isOccupied(index + 1)

                    // Важно: отключаем сглаживание, чтобы не было "грязных" стыков
                    antialiasing: false
                    z: 0
                }

                // Основной круг
                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: root.isOccupied(index) ? Colors.palette.m3secondaryContainer : "transparent"
                    antialiasing: true
                    z: 1 // Поверх мостика своего элемента

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
            }
        }
    }

    // 2. АКТИВНЫЙ ИНДИКАТОР (Flying Pill)
    Rectangle {
        id: activeIndicator
        width: root.activeSize
        height: root.activeSize
        radius: width / 2
        color: Colors.palette.m3primary
        z: 2
        antialiasing: true

        x: ((root.width - backgroundRow.width) / 2) + (root.currentIndex * (root.itemSize + root.spacing)) + (root.itemSize - root.activeSize) / 2

        anchors.verticalCenter: parent.verticalCenter

        Behavior on x {
            Anim {
                duration: Appearance.animDuration.expressiveFastSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
            }
        }
    }

    // 3. СЛОЙ ТЕКСТА
    Row {
        anchors.centerIn: parent
        spacing: root.spacing
        z: 3

        Repeater {
            model: HyprlandData.fullWorkspaces
            delegate: Item {
                width: root.itemSize
                height: root.itemSize

                StyledText {
                    anchors.centerIn: parent
                    text: model.id
                    font.weight: (root.currentIndex === index) ? Font.Bold : Font.Normal
                    color: (root.currentIndex === index) ? Colors.palette.m3onPrimary : Colors.palette.m3onSurface

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: HyprlandData.dispatch(`workspace ${model.id}`)
                }
            }
        }
    }

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            if (event.angleDelta.y < 0)
                HyprlandData.dispatch(`workspace r+1`);
            else if (event.angleDelta.y > 0)
                HyprlandData.dispatch(`workspace r-1`);
        }
    }
}
