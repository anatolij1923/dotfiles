import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common

BarPopup {
    id: root

    // Немного паддинга внутри попапа, если BarPopup его не дает сам
    // Если BarPopup наследует PanelWindow из прошлого примера, паддинги там уже есть.

    // Логика форматирования времени
    function formatTime(seconds) {
        if (!seconds || seconds <= 0)
            return "--m";
        // Иногда UPower выдает гигантские числа при пересчете
        if (seconds > 86400)
            return "Calculating...";

        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);

        if (h > 0)
            return `${h}h ${m}m`;
        return `${m}m`;
    }

    ColumnLayout {
        spacing: 8

        // --- ЗАГОЛОВОК ---
        RowLayout {
            spacing: 8

            StyledText {
                text: "Battery"
                weight: 500
                size: 22
            }
            Layout.alignment: Qt.AlignHCenter
        }

        // --- ВИЗУАЛЬНЫЙ БАР (Progress Bar) ---
        // Rectangle {
        //     Layout.fillWidth: true
        //     Layout.topMargin: 4
        //     Layout.bottomMargin: 8
        //     height: 6
        //     radius: 3
        //     color: Colors.palette.m3surfaceVariant // Фон полоски (серый)
        //
        //     Rectangle {
        //         id: fillBar
        //         height: parent.height
        //         radius: parent.radius
        //         color: root.batteryColor
        //
        //         // Анимация изменения ширины
        //         width: (parent.width * Battery.percentage) / 100
        //         Behavior on width {
        //             NumberAnimation {
        //                 duration: 400
        //                 easing.type: Easing.OutCubic
        //             }
        //         }
        //
        //         // Анимация цвета
        //         Behavior on color {
        //             ColorAnimation {
        //                 duration: 200
        //             }
        //         }
        //     }
        // }

        // --- СЕТКА С ДЕТАЛЯМИ ---
        GridLayout {
            columns: 2
            Layout.fillWidth: true
            columnSpacing: 10
            rowSpacing: 6

            // 1. Статус
            MaterialSymbol {
                icon: "info"
                color: Colors.palette.m3secondary
            }
            StyledText {
                Layout.fillWidth: true
                text: Battery.isCharging ? "Charging" : (Battery.percentage < 20 ? "Low Battery" : "Discharging")
            }

            // 2. Время
            MaterialSymbol {
                icon: "hourglass_bottom"
                color: Colors.palette.m3secondary
            }
            StyledText {
                Layout.fillWidth: true
                text: {
                    if (Battery.isCharging) {
                        if (Battery.percentage >= 99)
                            return "Fully Charged";
                        return root.formatTime(Battery.timeToFull) + " to full";
                    } else {
                        return root.formatTime(Battery.timeToEmpty) + " remaining";
                    }
                }
                color: Colors.palette.m3onSurface
            }

            // 3. Мощность (Ватты)
            MaterialSymbol {
                icon: "bolt" // Или "speed", "flash_on"
                color: Colors.palette.m3secondary
                visible: Battery.energyRate > 0 // Скрываем, если данных нет
                fill: 1
            }
            StyledText {
                Layout.fillWidth: true
                visible: Battery.energyRate > 0
                // toFixed(1) делает "12.4" вместо "12.4123123"
                text: Battery.energyRate.toFixed(1) + " W"
                color: Colors.palette.m3onSurface
            }
        }
    }
}
