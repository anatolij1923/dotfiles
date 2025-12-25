import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.config

Rectangle {
    id: root

    readonly property int internalPadding: 4

    height: (parent && parent.height) ? parent.height - 8 : 36

    readonly property int itemSize: root.height - (root.internalPadding * 2)

    readonly property int activeSize: itemSize - 4

    readonly property int spacing: Appearance.padding.small

    implicitWidth: (HyprlandData.fullWorkspaces.count * (root.itemSize + root.spacing)) - root.spacing + (root.internalPadding * 4)

    implicitHeight: root.height

    radius: Appearance.rounding.full
    color: Colors.palette.m3surfaceContainer

    property int currentIndex: 0
    function updateIndex() {
        if (!HyprlandData.fullWorkspaces)
            return;
        for (let i = 0; i < HyprlandData.fullWorkspaces.count; i++) {
            if (HyprlandData.fullWorkspaces.get(i).id === HyprlandData.activeWsId) {
                currentIndex = i;
                break;
            }
        }
    }

    function isOccupied(index) {
        if (!HyprlandData.fullWorkspaces || index < 0 || index >= HyprlandData.fullWorkspaces.count)
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

                Rectangle {
                    id: bridge
                    width: root.itemSize + root.spacing
                    height: parent.height
                    x: parent.width / 2
                    color: Colors.palette.m3secondaryContainer
                    visible: root.isOccupied(index) && root.isOccupied(index + 1)
                    antialiasing: false
                    z: 0
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Appearance.rounding.full
                    color: root.isOccupied(index) ? Colors.palette.m3secondaryContainer : "transparent"
                    antialiasing: true
                    z: 1
                }
            }
        }
    }

    Rectangle {
        id: activeIndicator
        width: root.activeSize
        height: root.activeSize
        radius: Appearance.rounding.full
        color: Colors.palette.m3primary
        z: 2

        x: ((root.width - backgroundRow.width) / 2) + (root.currentIndex * (root.itemSize + root.spacing)) + (root.itemSize - root.activeSize) / 2

        anchors.verticalCenter: parent.verticalCenter

        Behavior on x {
            Anim {
                duration: Appearance.animDuration.expressiveFastSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
            }
        }
    }

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
                            duration: Appearance.animDuration.expressiveEffects
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
