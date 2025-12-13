import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

BarWidget {
    id: root

    RowLayout {
        id: content
        // anchors.centerIn: parent

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
