import QtQuick
import QtQuick.Layouts
import qs.settings
import qs.common
import qs.widgets
import qs.services

ContentPage {
    title: "Test Page"

    // Section: Buttons
    ColumnLayout {
        Layout.fillWidth: true
        Layout.leftMargin: Appearance.padding.large * 4
        Layout.rightMargin: Appearance.padding.large * 4
        spacing: Appearance.padding.normal

        StyledText {
            text: "Buttons"
            font.pixelSize: 20
            font.weight: Font.Medium
            color: Colors.palette.m3onSurfaceVariant
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Appearance.padding.normal

            TextButton {
                text: "Primary Button"
                onClicked: console.log("Primary button clicked")
            }

            TextButton {
                text: "Toggle Button"
                toggle: true
                onClicked: console.log("Toggle button:", checked)
            }

            TextButton {
                text: "Disabled"
                enabled: false
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Appearance.padding.normal

            IconButton {
                icon: "favorite"
                iconSize: 24
                onClicked: console.log("Icon button clicked")
            }

            IconButton {
                icon: "star"
                iconSize: 24
                toggle: true
                checked: true
                onClicked: console.log("Icon toggle:", checked)
            }

            TextIconButton {
                icon: "settings"
                text: "Settings"
                onClicked: console.log("TextIcon button clicked")
            }

            TextIconButton {
                icon: "palette"
                text: "Appearance"
                toggle: true
                onClicked: console.log("TextIcon toggle:", checked)
            }
        }
    }

    // Section: Inputs
    ColumnLayout {
        Layout.fillWidth: true
        Layout.leftMargin: Appearance.padding.large * 4
        Layout.rightMargin: Appearance.padding.large * 4
        spacing: Appearance.padding.normal

        StyledText {
            text: "Inputs"
            font.pixelSize: 20
            font.weight: Font.Medium
            color: Colors.palette.m3onSurfaceVariant
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Appearance.rounding.normal
            color: Colors.palette.m3surfaceContainer
            border.width: 1
            border.color: Colors.palette.m3outline

            StyledTextField {
                id: textField
                anchors.fill: parent
                anchors.margins: Appearance.padding.normal
                placeholder: "Enter text here..."
                fontSize: 16
            }
        }

        StyledText {
            text: "Text entered: " + (textField.text || "(empty)")
            font.pixelSize: 14
            color: Colors.palette.m3onSurfaceVariant
        }
    }

    // Section: Sliders
    ColumnLayout {
        Layout.fillWidth: true
        Layout.leftMargin: Appearance.padding.large * 4
        Layout.rightMargin: Appearance.padding.large * 4
        spacing: Appearance.padding.normal

        StyledText {
            text: "Sliders"
            font.pixelSize: 20
            font.weight: Font.Medium
            color: Colors.palette.m3onSurfaceVariant
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Appearance.padding.smaller

            StyledText {
                text: "Volume: " + Math.round(volumeSlider.value * 100) + "%"
                font.pixelSize: 14
                color: Colors.palette.m3onSurfaceVariant
            }

            StyledSlider {
                id: volumeSlider
                value: 0.5
                configuration: StyledSlider.Configuration.M
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Appearance.padding.smaller

            StyledText {
                text: "Brightness: " + Math.round(brightnessSlider.value * 100) + "%"
                font.pixelSize: 14
                color: Colors.palette.m3onSurfaceVariant
            }

            StyledSlider {
                id: brightnessSlider
                value: 0.75
                configuration: StyledSlider.Configuration.L
            }
        }
    }

    // Section: Toggles
    ColumnLayout {
        Layout.fillWidth: true
        Layout.leftMargin: Appearance.padding.large * 4
        Layout.rightMargin: Appearance.padding.large * 4
        spacing: Appearance.padding.normal

        StyledText {
            text: "Toggles"
            font.pixelSize: 20
            font.weight: Font.Medium
            color: Colors.palette.m3onSurfaceVariant
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Appearance.padding.normal

            TextIconButton {
                icon: "notifications"
                text: "Notifications"
                toggle: true
                checked: true
                onClicked: console.log("Notifications:", checked)
            }

            TextIconButton {
                icon: "dark_mode"
                text: "Dark Mode"
                toggle: true
                checked: false
                onClicked: console.log("Dark Mode:", checked)
            }

            TextIconButton {
                icon: "wifi"
                text: "WiFi"
                toggle: true
                checked: true
                onClicked: console.log("WiFi:", checked)
            }
        }
    }

    // Bottom spacing
    Item {
        Layout.fillWidth: true
        Layout.minimumHeight: Appearance.padding.large
    }
}
