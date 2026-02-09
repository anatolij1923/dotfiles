import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services
import qs.config

Rectangle {
    id: root

    property alias rowContent: layout.data

    property alias spacing: layout.spacing

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    property bool transparentWidgets: Config.bar.transparentCenterWidgets

    implicitHeight: parent.height * 0.8

    implicitWidth: layout.implicitWidth + (padding * 2)

    property int padding: Appearance.spacing.md

    radius: Appearance.rounding.lg
    color: transparentWidgets ? "transparent" : transparent ? Qt.alpha(Colors.palette.m3surfaceContainerLow, alpha - 0.2) : Colors.palette.m3surfaceContainerLow

    Behavior on color {
        CAnim {}
    }

    RowLayout {
        id: layout
        z: 100
        anchors.centerIn: parent
        spacing: 4
    }
}
