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

    RowLayout {
        id: pills
        spacing: 4
        Layout.alignment: Qt.AlignVCenter

        Repeater {
            model: HyprlandData.fullWorkspaces

            delegate: Rectangle {
                id: pill

                width: model.focused ? 32 : 16
                height: 16
                radius: 8

                color: model.focused ? Colors.palette.m3primary : (model.occupied ? Colors.palette.m3secondary : Colors.palette.m3surfaceVariant)

                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: width

                Behavior on width {
                    NumberAnimation {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Appearance.animDuration.expressiveEffectsDuration
                        easing.bezierCurve: Appearance.animCurves.expressiveEffects
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

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (HyprlandData.activeWsId !== model.id)
                            HyprlandData.dispatch(`workspace ${model.id}`);
                    }
                }
            }
        }
    }
}
