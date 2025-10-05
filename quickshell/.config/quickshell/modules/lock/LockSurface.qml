import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import qs
import qs.modules.lock
import qs.modules.common
import qs.services

WlSessionLockSurface {
    id: root
    required property LockContext context
    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false
    property bool active: false
    property bool showInputField: active || context.currentText.length > 0

    color: "transparent"

    // blurred background
    ScreencopyView {
        id: background
        anchors.fill: parent
        captureSource: root.screen
        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1
            blurMax: 10
            blurMultiplier: 1
        }
    }

    // background dim
    Rectangle {
        color: "black"
        anchors.fill: background
        opacity: 0.6
    }

    Item {
        id: login
        anchors.fill: parent
        opacity: GlobalStates.screenLocked ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 5000
                easing.type: Easing.InOutQuad
            }
        }

        // Button {
        //     onClicked: context.unlocked()
        // }

        Item {
            id: clock
            anchors {
                // centerIn: parent
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 180
            }

            // Rectangle {
            //     width: 100
            //     height: 50
            //     color: "red"
            // }
            //
            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                StyledText {
                    Layout.alignment: Qt.AlignCenter
                    text: Time.format("hh:mm")
                    size: 128
                    weight: 600
                }
                StyledText {
                    Layout.alignment: Qt.AlignCenter
                    text: Time.format("dddd dd MMMM")
                    size: 24
                    weight: 600
                }
            }
        }

        ColumnLayout {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 40
            }

            StyledTextField {
                id: passwordBox

                // opacity: root.showInputField ? 1 : 0

                implicitWidth: 300
                radius: 40
                padding: 20
                focus: true
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: root.context.currentText = this.text
                onAccepted: root.context.tryUnlock()

                placeholder: "Enter password"
                placeholderTextColor: Colors.surface_variant

                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText;
                    }
                }
            }
        }
    }
}
