import QtQuick
import QtQuick.Controls
import qs.services
import qs.common
import qs.widgets

SpinBox {
    id: root

    property int baseHeight: 40
    property int radius: Appearance.rounding.normal
    property int innerRadius: Appearance.rounding.small

    background: Rectangle {
        color: Colors.palette.m3surfaceContainerHighest

        radius: root.radius
    }

    down.indicator: Rectangle {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        implicitHeight: root.baseHeight
        implicitWidth: root.baseHeight

        color: root.down.pressed ? Qt.alpha(Colors.palette.m3onSurface, 0.1) : root.down.hovered ? Qt.alpha(Colors.palette.m3onSurface, 0.08) : Colors.palette.m3surfaceContainerHighest

        topLeftRadius: root.radius
        bottomLeftRadius: root.radius
        topRightRadius: root.innerRadius
        bottomRightRadius: root.innerRadius

        MaterialSymbol {
            icon: "remove"
            anchors.centerIn: parent
            color: Colors.palette.m3onSurface
        }
    }

    contentItem: StyledTextField {
        id: input

        text: root.value
        anchors.centerIn: parent

        leftPadding: Appearance.padding.normal
        rightPadding: Appearance.padding.normal

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        validator: root.validator

        placeholderText: ""

        onTextChanged: {
            root.value = parseFloat(text);
        }
    }

    up.indicator: Rectangle {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        implicitHeight: root.baseHeight
        implicitWidth: root.baseHeight

        color: root.up.pressed ? Qt.alpha(Colors.palette.m3onSurface, 0.1) : root.up.hovered ? Qt.alpha(Colors.palette.m3onSurface, 0.08) : Colors.palette.m3surfaceContainerHighest

        topRightRadius: root.radius
        bottomRightRadius: root.radius
        topLeftRadius: root.innerRadius
        bottomLeftRadius: root.innerRadius

        MaterialSymbol {
            icon: "add"
            anchors.centerIn: parent
            color: Colors.palette.m3onSurface
        }
    }
}
