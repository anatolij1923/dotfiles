import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

Rectangle {
    id: root
    implicitHeight: parent.height - 8
    implicitWidth: content.implicitWidth + Appearance.padding.normal * 2
    radius: Appearance.rounding.normal

    color: Colors.palette.m3surfaceContainerLow

    RowLayout {
        id: content
        anchors.centerIn: parent

        MaterialSymbol {
            icon: Weather.data.icon
            color: Colors.palette.m3onSurface
        }

        StyledText {
            text: Weather.data.temp
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    WeatherPopup {
        id: weatherPopup
        hoverTarget: mouseArea
    }
}
