import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.widgets
import qs.services

Item {
    id: root
    property var entry: modelData
    signal triggered
    signal openSubmenu(var handle)

    implicitWidth: mainRow.implicitWidth + 20
    implicitHeight: entry.isSeparator ? 10 : 36

    width: parent ? parent.width : implicitWidth

    StateLayer {
        id: interaction
        visible: !entry.isSeparator
        anchors.fill: parent
        anchors.margins: 2
        radius: 6
        disabled: !entry.enabled
        color: Colors.palette.m3onSurface

        onClicked: {
            if (entry.hasChildren) {
                root.openSubmenu(root.entry);
            } else {
                entry.triggered();
                root.triggered();
            }
        }
    }

    Rectangle {
        visible: entry.isSeparator
        anchors.centerIn: parent
        width: parent.width - 16
        height: 1
        color: Colors.palette.m3onSurface
        opacity: 0.2
    }

    RowLayout {
        id: mainRow
        visible: !entry.isSeparator
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            active: entry.buttonType !== QsMenuButtonType.None

            sourceComponent: MaterialSymbol {
                icon: entry.checkState === Qt.Checked ? "check_box" : "check_box_outline_blank"
                color: Colors.palette.m3primary
                fill: 1
            }
        }        

            // StyledText {
            //     text: `${entry.checkState === Qt.Checked}`
            // }
            // StyledText {
            //     text: `${entry.buttonType === QsMenuButtonType.RadioButton}`
            // }

        IconImage {
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18
            source: entry.icon || ""
            visible: entry.icon !== "" && 
                    typeof entry.checked === 'undefined' && 
                    typeof entry.checkState === 'undefined' && 
                    typeof entry.toggled === 'undefined'
        }

        StyledText {
            id: txt
            text: entry.text || ""
            Layout.fillWidth: true
            color: entry.enabled ? Colors.palette.m3onSurface : Colors.palette.m3outline
            elide: Text.ElideRight
        }

        StyledText {
            text: "›"
            visible: entry.hasChildren
            color: Colors.palette.m3outline
        }
    }
}
