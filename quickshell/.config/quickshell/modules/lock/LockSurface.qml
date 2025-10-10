pragma ComponentBehavior: Bound
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
    property bool showFailure: context.showFailure
    property bool active: false
    property bool showInputField: active || context.currentText.length > 0
    property bool startAnimation: false

    color: "transparent"

    // blurred background
    ScreencopyView {
        id: background
        anchors.fill: parent
        captureSource: root.screen
        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: root.startAnimation ? 1 : 0
            Behavior on blur {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
            blurMax: 35
            blurMultiplier: 1
        }
    }

    // background dim
    Rectangle {
        color: "black"
        anchors.fill: background
        opacity: root.startAnimation ? 0.2 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutBack
            }
        }
    }

    Item {
        id: login
        anchors.fill: parent
        opacity: root.startAnimation ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 10
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
                implicitHeight: 56
                radius: 40
                focus: true
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                icon: "person"

                onTextChanged: root.context.currentText = this.text
                onAccepted: root.context.tryUnlock()

                placeholder: root.showFailure ? "Wrong password" : Quickshell.env("USER")
                placeholderTextColor: Colors.on_surface_variant

                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                SequentialAnimation {
                    id: shakeAnimation
                    running: false
                    loops: 1
                    NumberAnimation {
                        target: passwordBox
                        property: "x"
                        duration: 50
                        from: 0
                        to: 10
                    }
                    NumberAnimation {
                        target: passwordBox
                        property: "x"
                        duration: 50
                        from: 10
                        to: -10
                    }
                    NumberAnimation {
                        target: passwordBox
                        property: "x"
                        duration: 50
                        from: -10
                        to: 10
                    }
                    NumberAnimation {
                        target: passwordBox
                        property: "x"
                        duration: 50
                        from: 10
                        to: 0
                    }
                }

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText;
                    }
                }
                Connections {
                    target: root.context
                    function onUnlocked() {
                        startAnimation = false;
                    }
                }
                Connections {
                    target: root.context
                    function onShowFailureChanged() {
                        if (root.context.showFailure) {
                            shakeAnimation.start();
                        }
                    }
                }
            }
            Component.onCompleted: {
                root.startAnimation = true;
            }
        }
    }
}
