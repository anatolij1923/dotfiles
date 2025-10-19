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
import qs.modules.bar

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

    // Dim
    Rectangle {
        anchors.fill: parent
        color: "black"
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

        RowLayout {
            spacing: 16

            scale: root.startAnimation ? 1 : 0.95
            opacity: root.startAnimation ? 1 : 0

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity { 
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 40
            }

            Rectangle {
                color: Colors.surface_container
                radius: 32
                implicitWidth: kbLayout.implicitWidth + (passwordBox.implicitHeight * 0.5)
                implicitHeight: passwordBox.implicitHeight
                KbLayout {
                    id: kbLayout
                    anchors.centerIn: parent
                }
            }

            StyledTextField {
                id: passwordBox

                // opacity: root.showInputField ? 1 : 0

                implicitWidth: Math.max(300, parent.width * 0.3) // Адаптивно к размеру экрана
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
                    PropertyAnimation {
                        target: passwordBox
                        property: "Layout.leftMargin"
                        duration: 50
                        from: 0
                        to: 10
                    }
                    PropertyAnimation {
                        target: passwordBox
                        property: "Layout.leftMargin"
                        duration: 50
                        from: 10
                        to: -10
                    }
                    PropertyAnimation {
                        target: passwordBox
                        property: "Layout.leftMargin"
                        duration: 50
                        from: -10
                        to: 10
                    }
                    PropertyAnimation {
                        target: passwordBox
                        property: "Layout.leftMargin"
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

            Rectangle {
                id: tools
                implicitHeight: passwordBox.implicitHeight
                implicitWidth: toolsRow.implicitWidth + 24
                color: Colors.surface_container
                radius: 32

                RowLayout {
                    id: toolsRow
                    anchors.centerIn: parent
                    spacing: 8

                    IconButton {
                        radius: Appearance.rounding.full
                        icon: "bedtime"
                        iconSize: 24
                        implicitHeight: 40
                        implicitWidth: 40
                        onClicked: Session.suspend()
                    }

                    IconButton {
                        radius: Appearance.rounding.full
                        icon: "refresh"
                        iconSize: 24
                        implicitHeight: 40
                        implicitWidth: 40
                        // onClicked: Session.reboot()
                    }
                    IconButton {
                        radius: Appearance.rounding.full
                        icon: "power_settings_new"
                        iconSize: 24
                        implicitHeight: 40
                        implicitWidth: 40
                        // onClicked: Session.poweroff()
                    }

                    BatteryWidget {}
                }
            }

            Component.onCompleted: {
                root.startAnimation = true;
            }
        }
    }
}
