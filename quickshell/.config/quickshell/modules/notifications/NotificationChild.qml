import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.services
import Quickshell.Services.Notifications
import qs.modules.common

Item {
    id: root
    implicitWidth: 450
    implicitHeight: content.implicitHeight + 35

    property string title: ""
    property string appIcon: ""
    property string appName: ""
    property string body: ""
    property string image: ""
    property string time: ""
    property var rawNotif
    property list<var> buttons: []

    property bool expanded: false


    ClippingRectangle {
        id: bg
        anchors.fill: parent
        radius: Appearance.rounding.huge
        color: Colors.surface_container
        border.color: Qt.alpha(Colors.outline_variant, 0.4)
        border.width: 1

        ColumnLayout {
            id: content
            anchors.fill: parent
            spacing: 16
            Layout.fillHeight: true
            anchors.margins: Appearance.padding.large
            RowLayout {
                id: header
                Layout.fillWidth: true
                spacing: 8

                Image {
                    source: Quickshell.iconPath(root.appIcon)
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    visible: root.appIcon !== ""
                    smooth: true
                }

                StyledText {
                    id: appName
                    text: root.appName
                    color: Qt.alpha(Colors.on_surface, 0.5)
                    weight: 400
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    id: time
                    text: root.time
                    weight: 400
                    color: Qt.alpha(Colors.on_surface, 0.5)
                }

                IconButton {
                    icon: root.expanded ? "keyboard_arrow_up" : "keyboard_arrow_down"
                    implicitHeight: 24
                    onClicked: () => {
                        root.expanded = !root.expanded;
                    }
                }
            }

            RowLayout {
                id: body
                spacing: 8

                ClippingRectangle {
                    radius: Appearance.rounding.normal
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 80
                    visible: root.image !== ""

                    Image {
                        id: image
                        anchors.fill: parent
                        source: root.image
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    Layout.alignment: Qt.AlignTop

                    StyledText {
                        text: root.title
                        // weight: 600
                        size: 20
                        wrapMode: Text.Wrap
                        color: Colors.on_surface
                    }

                    StyledText {
                        text: root.body
                        weight: 400
                        wrapMode: Text.Wrap
                        color: Qt.alpha(Colors.on_surface, 0.85)
                        visible: root.body !== ""
                    }
                }
            }

            RowLayout {
                id: actions
                Layout.alignment: Qt.AlignHCenter
                visible: root.expanded ? true : false

                states: [
                    State {
                        name: "expanded"
                        when: root.expanded
                        PropertyChanges {
                            target: actions
                            opacity: 1
                            Layout.preferredHeight: actions.implicitHeight
                        }
                    },
                    State {
                        name: "collapsed"
                        when: !root.expanded
                        PropertyChanges {
                            target: actions
                            opacity: 0
                            Layout.preferredHeight: 0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        Anim {
                            properties: "opacity, Layout.preferredHeight"
                            duration: Appearance.animDuration.expressiveDefaultSpatial
                            easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                        }
                    }
                ]

                TextButton {
                    text: "Close"
                    onClicked: modelData.close()
                    inactiveColor: Colors.surface_container_highest
                    padding: Appearance.padding.larger
                    Layout.fillWidth: true
                }

                Repeater {
                    model: root.buttons
                    delegate: TextButton {
                        text: modelData.label
                        onClicked: modelData.onClick()
                        inactiveColor: Colors.surface_container_highest
                        Layout.fillWidth: true

                        padding: Appearance.padding.larger
                    }
                }
            }
        }
    }
}

// Rectangle {
//     id: root
//
//
//     // color: modelData.urgency === NotificationUrgency.DialogButtonBox.Critical ? Colors.secondary_container : Colors.surface_container
//
//     property bool expanded
//     radius: Appearance.rounding.normal
//     required property Notifications.Notif modelData
//
//     implicitWidth: 450 // TODO: move sizes in config or something
//     implicitHeight: content.implicitHeight
//
//     MouseArea {
//         anchors.fill: parent
//         hoverEnabled: true
//         cursorShape: Qt.ClosedHandCursor
//
//         Item {
//             id: content
//             property string title: ""
//             property string appIcon: ""
//             property string appName: ""
//             property string body: ""
//             property string image: ""
//             property string time: ""
//             property var rawNotif
//             property list<var> buttons: []
//
//             StyledText {
//                 id: appName
//                 text: root.appName
//             }
//         }
//     }
// }

