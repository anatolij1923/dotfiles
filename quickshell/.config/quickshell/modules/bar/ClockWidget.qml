import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs
import qs.modules.common
import qs.services

StyledText {
    text: Time.format("hh:mm - ddd dd MMM.")
    size: 18
    weight: 400
}
