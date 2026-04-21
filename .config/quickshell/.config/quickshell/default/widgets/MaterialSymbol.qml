import QtQuick

Text {
    id: root
    property real fill: 0
    property int grad: 0
    property int size: 24
    property int weight: 500
    required property string icon

    font.family: "Material Symbols Rounded"
    font.hintingPreference: Font.PreferFullHinting
    font.variableAxes: {
        "FILL": root.fill,
        "opsz": root.fontInfo.pixelSize,
        "GRAD": root.grad,
        "wght": root.fontInfo.weight
    }
    renderType: Text.NativeRendering
    text: root.icon
    font.pixelSize: root.size
    font.weight: root.weight
}
