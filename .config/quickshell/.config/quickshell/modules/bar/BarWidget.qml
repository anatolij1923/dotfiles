import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

Rectangle {
    id: root

    // --- Свойства ---
    property alias spacing: layout.spacing

    // Высота такая же, как у виджетов (чтобы было ровно)
    implicitHeight: parent.height - 12

    // Ширина зависит от содержимого + отступы по краям
    implicitWidth: layout.implicitWidth + (padding * 2)

    // Внутренний отступ (от края капсулы до виджетов)
    property int padding: Appearance.padding.normal

    // Внешний вид капсулы
    radius: Appearance.rounding.small
    color: Colors.palette.m3surfaceContainerLow // Чуть темнее или светлее фона бара

    // --- Магия ---
    // Всё, что кидаем внутрь BarGroup, попадает в RowLayout
    default property alias content: layout.data

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 4 // Расстояние между виджетами внутри группы
    }
}
