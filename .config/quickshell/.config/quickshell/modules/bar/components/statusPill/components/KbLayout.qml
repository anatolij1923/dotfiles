import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets

StatusPillWidget {
    text: WmService.isNiri ? NiriService.currentLayout : HyprlandData.currentLayoutCode
}
