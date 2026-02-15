import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

ColumnLayout {
    id: root
    property string label
    property real value
    property real from: 0
    property real to: 100
    property real step: 1
    property string suffix: ""

    Layout.fillWidth: true
    spacing: 0

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 32

        StyledText {
            text: root.label
            Layout.fillWidth: true
        }

        StyledText {
            // Форматирование вынесено в Row для красоты
            text: (root.step >= 100 ? Math.round(root.value * 100) : root.value.toFixed(2)) + root.suffix
            color: Colors.palette.m3primary
            weight: Font.Bold
            size: Appearance.fontSize.sm
        }
    }

    StyledSlider {
        id: slider
        Layout.fillWidth: true
        value: root.value
        from: root.from
        to: root.to
        // Настройка шага и т.д.
        onMoved: root.value = value
    }
}
