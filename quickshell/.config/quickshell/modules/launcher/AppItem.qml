import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs

Button {
    id: appButton
    // Принимаем весь объект целиком
    property var entry

    background: Rectangle {
        radius: 6
        color: appButton.hovered ? Colors.surface_variant : "transparent"
    }

    contentItem: RowLayout {
        spacing: 10
        anchors.fill: parent
        anchors.margins: 8

        // Иконка приложения (из .desktop файла)
        Image {
            // Видна, только если у объекта есть поле .icon
            visible: entry.icon !== undefined
            source: Quickshell.iconPath(entry.icon, true)
            sourceSize.width: 24
            sourceSize.height: 24
        }

        // Иконка из Material Symbols (для калькулятора, веба и т.д.)
        // Тебе может понадобиться добавить компонент для MaterialSymbol, если его нет
        Text {
            // Видна, только если есть поле .materialSymbol
            visible: entry.materialSymbol !== undefined
            font.family: "Material Symbols Outlined" // Убедись, что шрифт подключен
            font.pixelSize: 24
            text: entry.materialSymbol
            color: Colors.on_surface
        }

        ColumnLayout {
            Layout.fillWidth: true
            Text {
                text: entry.name // Имя есть у всех
                color: Colors.on_surface
                font.pixelSize: 14
                elide: Text.ElideRight
            }
            Text {
                // Дополнительная инфа (тип), если она есть
                visible: entry.type !== undefined
                text: entry.type
                color: Colors.on_surface_variant
                font.pixelSize: 10
            }
        }
    }

    // Сигнал onClicked будет вызывать функцию execute из объекта
    onClicked: {
        if (entry.execute) {
            entry.execute();
        }
    }
}
