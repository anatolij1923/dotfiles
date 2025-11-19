import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common

BarPopup {
    id: root

    ColumnLayout {
        spacing: 5

        StyledText {
            text: "Weather"
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
