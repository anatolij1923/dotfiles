import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

// TODO: Add screen recording

QuickToggle {
    checked: Record.isRecording
    icon: "screen_record"

    onClicked: () => {
        Record.toggle();
    }
    StyledTooltip {
        text: "Enable screen recording"
        verticalPadding: 8
        horizontalPadding: 12
    }
}
