pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.common
import qs.widgets

Item {
    id: root

    required property string search
    property int spacing: Appearance.padding.small

    function activate() {
        if (currentItem && typeof currentItem.execute === "function") {
            currentItem.execute();
            return true;
        }
        return false;
    }

    property alias count: listView.count
    property alias currentIndex: listView.currentIndex
    readonly property Item currentItem: listView.currentItem
    function incrementCurrentIndex() {
        listView.incrementCurrentIndex();
    }
    function decrementCurrentIndex() {
        listView.decrementCurrentIndex();
    }

    // FIXME : clipboard object with image counting like its just a text but it has bigger size

    implicitHeight: listView.implicitHeight + (listView.count > 0 ? (footer.height + root.spacing) : 0)

    ListView {
        id: listView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: root.spacing
        implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing
        height: implicitHeight

        preferredHighlightBegin: 0
        preferredHighlightEnd: height
        highlightFollowsCurrentItem: false
        highlightRangeMode: ListView.ApplyRange

        model: ClipboardService.query(search.slice(11))
        currentIndex: 0

        clip: true

        highlight: Rectangle {
            color: Colors.palette.m3onSurface
            opacity: 0.1
            radius: Appearance.rounding.huge
            y: listView.currentItem?.y ?? 0
            implicitWidth: listView.width
            implicitHeight: listView.currentItem?.implicitHeight ?? 0

            Behavior on y {
                Anim {
                    duration: Appearance.animDuration.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                }
            }
        }

        delegate: ClipboardItem {}
    }

    Item {
        id: footer
        visible: listView.count > 0

        anchors {
            top: listView.bottom
            topMargin: root.spacing
            left: parent.left
            right: parent.right
        }

        height: clearButton.implicitHeight

        StyledText {
            id: countText
            text: `${listView.count} ${Translation.tr("launcher.entries")}`
            color: Colors.palette.m3onSurfaceVariant

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Appearance.padding.small
            }
        }

        TextIconButton {
            id: clearButton

            icon: "delete_sweep"
            iconSize: 32
            text: Translation.tr("launcher.wipe")
            textSize: 18
            textWeight: 500

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: Appearance.padding.small
            }

            horizontalPadding: Appearance.padding.large

            onClicked: {
                ClipboardService.wipe();
            }
        }
    }
}
