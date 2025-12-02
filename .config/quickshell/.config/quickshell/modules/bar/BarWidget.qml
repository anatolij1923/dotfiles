import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs.config

Rectangle {
    id: root

    property alias spacing: layout.spacing

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    implicitHeight: parent.height - 12

    implicitWidth: layout.implicitWidth + (padding * 2)

    property int padding: Appearance.padding.normal

    radius: Appearance.rounding.small
    color: transparent ? Qt.alpha(Colors.palette.m3surfaceContainerLow, alpha - 0.2) : Colors.palette.m3surfaceContainerLow
    Behavior on color {
        CAnim {}
    }

    default property alias content: layout.data

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 4
    }
}
