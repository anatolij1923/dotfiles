import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common

BarPopup {
    id: root

    ColumnLayout {
        spacing: 12 // Чуть больше воздуха между секциями

        // --- ЗАГОЛОВОК: ГОРОД ---
        StyledText {
            text: Weather.data.city
            size: 22
            weight: 600 // Полужирный
            Layout.alignment: Qt.AlignHCenter
        }

        // --- ОСНОВНОЙ БЛОК: ИКОНКА И ТЕМПЕРАТУРА ---
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            // Большая иконка погоды
            MaterialSymbol {
                icon: Weather.data.icon
                font.pixelSize: 48 // Крупный размер
                color: Colors.palette.m3onSurface
            }

            ColumnLayout {
                spacing: 0
                // Огромная температура
                StyledText {
                    text: Weather.data.temp + "°"
                    size: 42
                    weight: 300 // Тонкий шрифт для больших цифр смотрится стильно
                }
                // Текстовое описание (Sunny, Rain и т.д.)
                StyledText {
                    text: Weather.data.desc
                    color: Colors.palette.m3secondary // Чуть приглушенный цвет
                    size: 16
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // --- СЕТКА ДЕТАЛЕЙ ---
        GridLayout {
            columns: 2
            Layout.fillWidth: true
            columnSpacing: 20
            rowSpacing: 10

            // 1. Ощущается как
            RowLayout {
                spacing: 8
                MaterialSymbol {
                    icon: "thermostat"
                    color: Colors.palette.m3secondary
                }
                StyledText {
                    text: "Feels like " + Weather.data.tempFeelsLike + "°"
                }
            }

            // 2. Ветер
            RowLayout {
                spacing: 8
                MaterialSymbol {
                    icon: "air"
                    color: Colors.palette.m3secondary
                }
                StyledText {
                    text: Weather.data.wind + " km/h"
                }
            }

            // 3. Мин / Макс температура за сегодня
            RowLayout {
                spacing: 8
                MaterialSymbol {
                    icon: "vertical_align_center"
                    color: Colors.palette.m3secondary
                }
                StyledText {
                    // Собираем в одну строку
                    text: "L: " + Weather.data.minTemp + "°  H: " + Weather.data.maxTemp + "°"
                }
            }

            // 4. Влажность
            RowLayout {
                spacing: 8
                MaterialSymbol {
                    icon: "water_drop"
                    color: Colors.palette.m3secondary
                }
                StyledText {
                    text: Weather.data.humidity + "%"
                }
            }
        }
    }
}
