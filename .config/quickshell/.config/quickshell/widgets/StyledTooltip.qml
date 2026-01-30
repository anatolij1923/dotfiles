import qs.common
import qs.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services

ToolTip {
    id: root
    property bool extraVisibleCondition: true
    property bool alternativeVisibleCondition: false
    readonly property bool internalVisibleCondition: (extraVisibleCondition && (parent.hovered === undefined || parent?.hovered)) || alternativeVisibleCondition
    verticalPadding: Appearance.padding.normal
    horizontalPadding: Appearance.padding.larger

    background: null

    visible: internalVisibleCondition

    contentItem: StyledTooltipContent {
        id: contentItem
        text: root.text
        shown: root.internalVisibleCondition
        horizontalPadding: root.horizontalPadding
        verticalPadding: root.verticalPadding
    }
}
