pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.modules.common
import qs.services

Slider {
    id: root

    property list<real> stopIndicatorValues: [1]

    enum Configuration {
        Wavy = 4,
        XS = 12,
        S = 18,
        M = 30,
        L = 42,
        XL = 72
    }

    property var configuration: StyledSlider.Configuration.S

    property real handleDefaultWidth: 3
    property real handlePressedWidth: 1.5
    property color highlightColor: Colors.palette.m3primary
    property color trackColor: Colors.palette.m3secondaryContainer
    property color handleColor: Colors.palette.m3primary
    property color dotColor: Colors.palette.m3onSecondaryContainer
    property color dotColorHighlighted: Colors.palette.m3onPrimary
    property real unsharpenRadius: Appearance.rounding.unsharpen
    property real trackWidth: configuration
    property real trackRadius: trackWidth >= StyledSlider.Configuration.XL ? 21 : trackWidth >= StyledSlider.Configuration.L ? 12 : trackWidth >= StyledSlider.Configuration.M ? 9 : trackWidth >= StyledSlider.Configuration.S ? 6 : height / 2
    property real handleHeight: (configuration === StyledSlider.Configuration.Wavy) ? 24 : Math.max(33, trackWidth + 9)
    property real handleWidth: root.pressed ? handlePressedWidth : handleDefaultWidth
    property real handleMargins: 4
    property real trackDotSize: 3
    property string tooltipContent: `${Math.round(value * 100)}%`

    leftPadding: handleMargins
    rightPadding: handleMargins
    property real effectiveDraggingWidth: width - leftPadding - rightPadding

    Layout.fillWidth: true

    from: 0
    to: 1

    Behavior on value {
        // This makes the adjusted value (like volume) shift smoothly
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
        // SmoothedAnimation {
        //     velocity: 800
        // }
    }

    Behavior on handleMargins {
        animation: Appearance.anim.elementMoveFast.numberAnimation.createObject(this)
    }
    MouseArea {
        anchors.fill: parent
        onPressed: mouse => mouse.accepted = false
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
    }

    component TrackDot: Rectangle {
        required property real value
        property real normalizedValue: (value - root.from) / (root.to - root.from)
        anchors.verticalCenter: parent.verticalCenter
        x: root.handleMargins + (normalizedValue * root.effectiveDraggingWidth) - (root.trackDotSize / 2)
        width: root.trackDotSize
        height: root.trackDotSize
        radius: Appearance.rounding.full
        color: normalizedValue > root.visualPosition ? root.dotColor : root.dotColorHighlighted

        Behavior on color {
            animation: Appearance.anim.elementMoveFast.colorAnimation.createObject(this)
        }
    }

    background: Item {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        implicitHeight: trackWidth

        Loader {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }

            width: root.handleMargins + (root.visualPosition * root.effectiveDraggingWidth) - (root.handleWidth / 2 + root.handleMargins)
            height: root.trackWidth
            sourceComponent: Rectangle {
                color: root.highlightColor
                topLeftRadius: root.trackRadius
                bottomLeftRadius: root.trackRadius
                topRightRadius: root.unsharpenRadius
                bottomRightRadius: root.unsharpenRadius
            }
        }

        Rectangle {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            width: root.handleMargins + ((1 - root.visualPosition) * root.effectiveDraggingWidth) - (root.handleWidth / 2 + root.handleMargins)
            height: trackWidth
            color: root.trackColor
            topRightRadius: root.trackRadius
            bottomRightRadius: root.trackRadius
            topLeftRadius: root.unsharpenRadius
            bottomLeftRadius: root.unsharpenRadius
        }

        Repeater {
            model: root.stopIndicatorValues
            TrackDot {
                required property real modelData
                value: modelData
                anchors.verticalCenter: parent?.verticalCenter
            }
        }
    }

    handle: Rectangle {
        id: handle

        implicitWidth: root.handleWidth
        implicitHeight: root.handleHeight
        x: root.handleMargins + (root.visualPosition * root.effectiveDraggingWidth) - (root.handleWidth / 2)
        anchors.verticalCenter: parent.verticalCenter
        radius: Appearance.rounding.full
        color: root.handleColor

        Behavior on implicitWidth {
            Anim {
                duration: Appearance.animDuration.expressiveEffects
                easing.bezierCurve: Appearance.animCurves.expressiveEffects
            }
        }
        StyledTooltip {
            extraVisibleCondition: root.pressed
            text: root.tooltipContent
            verticalPadding: 8
            horizontalPadding: 12
        }
    }
}
