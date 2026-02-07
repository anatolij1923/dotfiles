pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Dialogs
import QtQuick.Layouts
import qs.config
import qs.services
import qs.modules.launcher.items
import qs.common
import qs.widgets

Item {
    id: root
    required property string search
    required property real maxHeight

    function activate() {
        if (currentItem && typeof currentItem.execute === "function") {
            currentItem.execute();
            return false;
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

    readonly property string searchQuery: search.startsWith(":wallpaper") ? search.slice(":wallpaper".length).trim() : ""
    readonly property real spacing: Appearance.padding.normal

    property var wallpaperModel: []

    // Find and set the index of the currently active system wallpaper
    function syncCurrentIndex() {
        const currentPath = Wallpapers.actualCurrent;
        if (!currentPath)
            return;

        for (let i = 0; i < root.wallpaperModel.length; i++) {
            if (root.wallpaperModel[i] === currentPath) {
                listView.currentIndex = i;
                listView.positionViewAtIndex(i, ListView.Center);
                return;
            }
        }
    }

    function updateModel() {
        const result = Wallpapers.query(searchQuery);
        root.wallpaperModel = result;

        // Ensure the list is rendered before trying to position it
        Qt.callLater(() => {
            root.syncCurrentIndex();
        });
    }

    onSearchQueryChanged: updateModel()

    Connections {
        target: Wallpapers

        // Update list if files on disk change
        function onListChanged() {
            root.updateModel();
        }

        // Sync index when the active wallpaper changes (e.g. via Random button or external script)
        function onActualCurrentChanged() {
            root.syncCurrentIndex();
        }
    }

    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: Config.launcher.sizes.wallHeight + 110

    ListView {
        id: listView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Config.launcher.sizes.wallHeight + 70

        highlightMoveDuration: 350

        orientation: ListView.Horizontal
        spacing: root.spacing
        model: root.wallpaperModel
        currentIndex: 0

        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: (width - Config.launcher.sizes.wallWidth) / 2
        preferredHighlightEnd: (width + Config.launcher.sizes.wallWidth) / 2

        clip: false

        delegate: WallpaperItem {
            required property int index
            wallpaperPath: root.wallpaperModel[index]
        }

        Component.onCompleted: root.updateModel()
    }

    Item {
        id: footer
        visible: wallpaperModel.length > 0
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            bottomMargin: 5
        }
        height: randomButton.implicitHeight

        StyledText {
            text: `${root.wallpaperModel.length} wallpapers`
            color: Colors.palette.m3onSurfaceVariant
            size: 18
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Appearance.padding.small
            }
        }

        TextIconButton {
            id: randomButton

            icon: "casino"
            iconSize: 32
            text: "Random"
            textSize: 18
            textWeight: 500
            horizontalPadding: Appearance.padding.large

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: Appearance.padding.small
            }

            onClicked: {
                Wallpapers.setRandomWallpaper();
            }
        }
    }
}
