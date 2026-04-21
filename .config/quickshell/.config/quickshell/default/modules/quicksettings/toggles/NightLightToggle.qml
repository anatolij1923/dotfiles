import Quickshell
import QtQuick
import qs
import qs.common
import qs.widgets
import qs.services

QuickToggle {
    checked: NightLightService.running
    icon: "wb_twilight"

    onClicked: NightLightService.toggle()

    tooltipText: Translation.tr("quicksettings.toggles.night_light")
}
