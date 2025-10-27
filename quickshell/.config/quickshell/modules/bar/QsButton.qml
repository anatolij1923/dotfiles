import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs

Rectangle {
    id: qsButton
    implicitWidth: content.implicitWidth + 24
    implicitHeight: parent.height - 8
    color: GlobalStates.quicksettingsOpened === true ? Qt.alpha(Colors.primary, 0.3) : "transparent"
    radius: Appearance.rounding.huge

    Behavior on color {
        CAnim {
            duration: Appearance.animDuration.expressiveEffects
            easing.type: Appearance.animCurves.smaller
        }
    }

    StateLayer {
        anchors.fill: parent

        onClicked: () => {
            GlobalStates.quicksettingsOpened = true;
        }
    }

    RowLayout {
        id: content
        anchors.centerIn: parent

        spacing: 16

        NetworkWidget {}
        BluetoothWidget {}
    }
}
