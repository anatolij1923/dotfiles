import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
 // Import StyledButton

StyledButton {
    id: button
    buttonIcon: buttonIcon
    buttonText: buttonText
    buttonPadding: 16
    buttonRadius: 28
    buttonIconSize: 56
    buttonIconWeight: 700
    buttonTextSize: 18
    normalBg: Colors.palette.m3surfaceContainerHighest
    // normalHover: Colors.palette.m3surfaceVariant
    // focusedBg: Colors.palette.m3primary
    // focusedTextColor: Colors.palette.m3surface
    // normalTextColor: Colors.palette.m3onSurface


    
    // StyledButton handles focus and keyboard interaction internally
    // StyledButton's contentItem already uses ColumnLayout, MaterialSymbol, and StyledText
    // We just need to pass the properties.
    // The weights for icon and text are set within StyledButton's contentItem.
}
