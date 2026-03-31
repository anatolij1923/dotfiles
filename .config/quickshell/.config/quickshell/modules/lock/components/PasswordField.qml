pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.config
import qs.modules.lock
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root

    required property LockContext context

    property real shakeX: 0
    transform: Translate {
        x: root.shakeX
    }

    implicitHeight: 64
    implicitWidth: 350

    color: Colors.palette.m3surface
    radius: Appearance.rounding.full

    RowLayout {
        anchors {
            fill: parent
            margins: Appearance.spacing.sm
        }
        spacing: Appearance.spacing.sm

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: parent.height
            color: Colors.palette.m3surfaceContainer
            radius: Appearance.rounding.full

            MaterialSymbol {
                id: icon
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: Appearance.spacing.xl
                }
                icon: "person"
                color: Colors.palette.m3onSurface
            }

            StyledTextField {
                id: input
                anchors {
                    left: icon.right
                    verticalCenter: parent.verticalCenter
                }
                focus: true
                echoMode: TextInput.Password

                placeholder: root.context.showFailure ? Translation.tr("lock.wrong_password") : Quickshell.env("USER")
                placeholderTextColor: root.context.showFailure ? Colors.palette.m3error : Colors.palette.m3onSurfaceVariant

                onTextChanged: root.context.currentText = text
                onAccepted: root.context.tryUnlock()

                Connections {
                    target: root.context

                    function onCurrentTextChanged() {
                        input.text = root.context.currentText;
                    }
                    function onShowFailureChanged() {
                        if (root.context.showFailure) {
                            shakeAnimation.start();
                            input.text = "";
                        }
                    }
                }
            }
        }

        IconButton {
            implicitHeight: parent.height
            implicitWidth: implicitHeight

            icon: input.text === "" ? "lock" : "arrow_forward"
            checked: input.text !== ""

            onClicked: {
                root.context.tryUnlock();
            }
        }
    }

    SequentialAnimation {
        id: shakeAnimation
        NumberAnimation {
            target: root
            property: "shakeX"
            from: 0
            to: 15
            duration: 50
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: root
            property: "shakeX"
            from: 15
            to: -15
            duration: 50
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: root
            property: "shakeX"
            from: -15
            to: 10
            duration: 50
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: root
            property: "shakeX"
            from: 10
            to: 0
            duration: 50
            easing.type: Easing.InQuad
        }
    }
}
