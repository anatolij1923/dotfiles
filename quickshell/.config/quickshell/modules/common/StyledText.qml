import qs
import QtQuick
import QtQuick.Layouts

Text {
    id: root
    property int size: 18
    property int weight: 500
    Layout.alignment: Qt.AlignVCenter
    font.family: "Rubik"
    font.weight: weight
    font.pixelSize: size
    color: Colors.on_surface
    renderType: Text.NativeRendering
}
