import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.widgets

QuickToggle {
    checked: Record.isRecording
    icon: "screen_record"

    onClicked: () => {
        Record.toggle();
    }
    tooltipText: Translation.tr("quicksettings.toggles.screen_record")
}
