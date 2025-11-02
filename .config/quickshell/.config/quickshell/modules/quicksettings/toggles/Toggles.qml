import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    anchors.fill: parent
    RowLayout {
        id: buttonsRow
        anchors.centerIn: parent
        spacing: 8
        NetworkToggle {}
        BluetoothToggle {}
        DNDToggle {}
        MicToggle {}
        PowerprofilesToggle {}
    }
}
