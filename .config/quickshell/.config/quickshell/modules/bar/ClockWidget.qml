import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs
import qs.modules.common
import qs.services
import qs.config

StyledText {
    property string format: Config.time.format
    property string dateFormat: Config.time.dateFormat

    text: Time.format(`${format} • ${dateFormat}`)
    visible: Config.bar.clock.enabled
    size: 18
    weight: 400
}
