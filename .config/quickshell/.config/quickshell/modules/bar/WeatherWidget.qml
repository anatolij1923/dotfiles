import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

Item {
    id: root
    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    RowLayout {
        id: content
        anchors.fill: parent

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
