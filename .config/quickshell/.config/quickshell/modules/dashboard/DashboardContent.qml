pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.widgets
import qs.common
import qs.services
import qs

Rectangle {
    id: root

    property int roundingLarge: Appearance.rounding.large
    property int roundingSmall: Appearance.rounding.small
    property int roundingOuter: Appearance.rounding.huge

    property int marginOuter: Appearance.padding.large
    property int marginInner: Appearance.padding.small

    property int widgetBaseSize: 200
    property int sidebarWidth: 200
    property int playerCollapsedWidth: 180

    property bool isBottom: false
    property bool weatherExpanded: false

    focus: true
    Keys.onEscapePressed: {
        if (weatherExpanded)
            weatherExpanded = false;
        else
            GlobalStates.dashboardOpened = false;
    }

    color: Colors.palette.m3surface

    bottomLeftRadius: isBottom ? 0 : roundingOuter
    bottomRightRadius: isBottom ? 0 : roundingOuter
    topRightRadius: isBottom ? roundingOuter : 0
    topLeftRadius: isBottom ? roundingOuter : 0

    Item {
        id: container
        anchors {
            fill: parent
            margins: root.marginOuter
        }

        state: "default"

        Rectangle {
            id: weather
            color: Colors.palette.m3surfaceContainer

            radius: root.roundingLarge
            bottomRightRadius: root.roundingSmall
            topRightRadius: root.roundingSmall
            bottomLeftRadius: root.roundingSmall

            width: root.widgetBaseSize
            height: root.widgetBaseSize

            clip: true

            anchors {
                top: parent.top
                left: parent.left
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.weatherExpanded = !root.weatherExpanded
            }

            Text {
                anchors.centerIn: parent
                text: "Weather"
                color: "white"
            }
        }

        Rectangle {
            id: mediaPlayer
            color: Colors.palette.m3surfaceContainer
            radius: root.roundingSmall
            bottomLeftRadius: root.weatherExpanded ? root.roundingLarge : root.roundingSmall

            width: root.widgetBaseSize
            height: root.widgetBaseSize

            clip: true

            Text {
                anchors.centerIn: parent
                text: "Media"
                color: "white"
            }
        }

        Rectangle {
            id: usageInfo
            color: Colors.palette.m3surfaceContainer
            radius: root.roundingLarge
            topLeftRadius: root.roundingSmall
            bottomLeftRadius: root.roundingSmall

            width: root.sidebarWidth

            clip: true

            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

            UsageInfo {
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: clockAndCal
            color: Colors.palette.m3surfaceContainer
            radius: root.roundingLarge
            bottomRightRadius: root.roundingSmall
            bottomLeftRadius: root.weatherExpanded ? root.roundingSmall : root.roundingLarge
            topRightRadius: root.roundingSmall
            topLeftRadius: root.roundingSmall

            clip: true

            Text {
                anchors.centerIn: parent
                text: "Clock & Cal"
                color: "white"
            }
        }

        states: [
            State {
                name: "default"
                when: !root.weatherExpanded

                PropertyChanges {
                    target: weather
                    width: root.widgetBaseSize
                }

                AnchorChanges {
                    target: mediaPlayer
                    anchors.top: container.top
                    anchors.left: weather.right
                    anchors.right: usageInfo.left
                    anchors.bottom: undefined
                }
                PropertyChanges {
                    target: mediaPlayer
                    anchors.leftMargin: root.marginInner
                    anchors.rightMargin: root.marginInner
                    height: root.widgetBaseSize
                    width: undefined
                }

                AnchorChanges {
                    target: clockAndCal
                    anchors.top: weather.bottom
                    anchors.left: container.left
                    anchors.right: usageInfo.left
                    anchors.bottom: container.bottom
                }
                PropertyChanges {
                    target: clockAndCal
                    anchors.topMargin: root.marginInner
                    anchors.rightMargin: root.marginInner
                }
            },
            State {
                name: "expanded"
                when: root.weatherExpanded

                PropertyChanges {
                    target: weather
                    width: container.width - usageInfo.width - root.marginInner
                }

                AnchorChanges {
                    target: mediaPlayer
                    anchors.top: weather.bottom
                    anchors.left: container.left
                    anchors.right: undefined
                    anchors.bottom: undefined
                }
                PropertyChanges {
                    target: mediaPlayer
                    anchors.topMargin: root.marginInner
                    anchors.leftMargin: 0
                    width: root.playerCollapsedWidth
                    // Вычисляем высоту: (Контейнер - Погода - Отступ)
                    height: container.height - weather.height - root.marginInner
                }

                AnchorChanges {
                    target: clockAndCal
                    anchors.top: weather.bottom
                    anchors.left: mediaPlayer.right
                    anchors.right: usageInfo.left
                    anchors.bottom: container.bottom
                }
                PropertyChanges {
                    target: clockAndCal
                    anchors.topMargin: root.marginInner
                    anchors.leftMargin: root.marginInner
                    anchors.rightMargin: root.marginInner
                }
            }
        ]

        transitions: Transition {
            ParallelAnimation {
                AnchorAnimation {
                    duration: Appearance.animDuration.expressiveDefaultSpatial
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                }
                Anim {
                    properties: "width,height,anchors.leftMargin,anchors.rightMargin,anchors.topMargin"
                    duration: Appearance.animDuration.expressiveDefaultSpatial
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                }
            }
        }
    }
}
