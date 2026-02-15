import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

SpinBox {
    id: root

    property int baseHeight: 40
    implicitHeight: baseHeight
    implicitWidth: 160

    readonly property bool canDecrease: value > from
    readonly property bool canIncrease: value < to

    background: Item {}

    Timer {
        id: repeatTimer
        repeat: true
        property bool isIncrease: true

        onTriggered: {
            if (isIncrease)
                root.increase();
            else
                root.decrease();

            if (interval > 30) {
                interval = Math.max(30, interval - 40);
            }
        }
    }

    down.indicator: Rectangle {
        id: downRect
        x: 0
        height: parent.height
        width: parent.height
        radius: height / 2

        enabled: root.canDecrease
        opacity: enabled ? 1.0 : 0.3
        color: {
            if (!enabled)
                return Colors.palette.m3surfaceContainerHighest;
            if (downState.pressed)
                return Colors.palette.m3secondaryContainer; 
            if (downState.containsMouse)
                return Colors.palette.m3surfaceContainerHigh; 
            return Colors.palette.m3surfaceContainerHighest;
        }

        Behavior on color {
            CAnim {
            }
        }

        StateLayer {
            id: downState
            anchors.fill: parent
            radius: parent.radius
            color: Colors.palette.m3onSurface

            onPressed: {
                root.decrease(); 
                repeatTimer.isIncrease = false;
                repeatTimer.interval = 300; 
                repeatTimer.start();
            }
            onReleased: repeatTimer.stop()
            onCanceled: repeatTimer.stop()
        }

        MaterialSymbol {
            icon: "remove"
            anchors.centerIn: parent
            size: 20
            color: (downState.containsMouse || downState.pressed) && root.canDecrease ? Colors.palette.m3primary : Colors.palette.m3onSurface

            Behavior on color {
                CAnim {
                }
            }
        }
    }

    contentItem: Rectangle {
        anchors.left: root.down.indicator.right
        anchors.right: root.up.indicator.left
        anchors.leftMargin: 6
        anchors.rightMargin: 6

        height: parent.height
        radius: Appearance.rounding.full
        color: Colors.palette.m3surfaceContainerHighest

        border.width: 1
        border.color: root.activeFocus ? Colors.palette.m3primary : "transparent"
        Behavior on border.color {
            CAnim {}
        }

        StyledTextField {
            id: input
            anchors.fill: parent
            text: root.textFromValue(root.value, root.locale)
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter

            background: null
            color: Colors.palette.m3onSurface
            fontSize: Appearance.fontSize.md

            validator: root.validator
            inputMethodHints: Qt.ImhDigitsOnly

            onEditingFinished: {
                root.value = root.valueFromText(text, root.locale);
            }
        }
    }

    up.indicator: Rectangle {
        id: upRect
        x: parent.width - width
        height: parent.height
        width: parent.height
        radius: height / 2

        enabled: root.canIncrease
        opacity: enabled ? 1.0 : 0.3

        color: {
            if (!enabled)
                return Colors.palette.m3surfaceContainerHighest;
            if (upState.pressed)
                return Colors.palette.m3secondaryContainer;
            if (upState.containsMouse)
                return Colors.palette.m3surfaceContainerHigh;
            return Colors.palette.m3surfaceContainerHighest;
        }

        Behavior on color {
            CAnim {
            }
        }

        StateLayer {
            id: upState
            anchors.fill: parent
            radius: parent.radius
            color: Colors.palette.m3onSurface

            onPressed: {
                root.increase(); 
                repeatTimer.isIncrease = true;
                repeatTimer.interval = 400; 
                repeatTimer.start();
            }
            onReleased: repeatTimer.stop()
            onCanceled: repeatTimer.stop()
        }

        MaterialSymbol {
            icon: "add"
            anchors.centerIn: parent
            size: 20
            color: (upState.containsMouse || upState.pressed) && root.canIncrease ? Colors.palette.m3primary : Colors.palette.m3onSurface

            Behavior on color {
                CAnim {
                }
            }
        }
    }
}
