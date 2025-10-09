import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.modules.common

Item {
    width: content.implicitWidth

    RowLayout {
        // user info and uptime
        id: content
        ColumnLayout {
            StyledText {
                text: "anatolij1923"
            }
            StyledText {
                text: "Uptime: 4h 24m"
            }
        }
        RowLayout {
            Button {
                text: "gsd"
            }
            Button {
                text: "gsd"
            }
            Button {
                text: "gsd"
            }
        }
    }
}
