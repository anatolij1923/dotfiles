import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services

LazyLoader {
    id: root

    // Input properties
    property Item hoverTarget
    default property Item contentItem

    // Styling properties
    property int padding: 10
    property int radius: Appearance.rounding.large

    // Activate when mouse is over the target
    active: hoverTarget && hoverTarget.containsMouse

    component: PanelWindow {
        id: popupWindow

        color: "transparent"

        // Position relative to top-left, adjusted via margins
        anchors {
            top: true
            left: true
        }

        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: -1 // Don't shift other windows

        // Window size tracks the background size
        implicitWidth: bg.implicitWidth
        implicitHeight: bg.implicitHeight

        // Apply transparency mask for rounded corners
        mask: Region {
            item: bg
        }

        // === Positioning Logic ===
        margins {
            // Y Axis: Place below the target with a small offset
            top: {
                if (!root.hoverTarget)
                    return 0;
                const globalY = root.hoverTarget.mapToGlobal(0, 0).y;
                return globalY + root.hoverTarget.height + 15;
            }

            // X Axis: Center on target + clamp to screen edges
            left: {
                if (!root.hoverTarget)
                    return 0;

                const targetGlobalX = root.hoverTarget.mapToGlobal(0, 0).x;
                const screenW = popupWindow.screen ? popupWindow.screen.width : 1920;

                const popupW = bg.implicitWidth;
                const targetW = root.hoverTarget.width;
                const marginOffset = 5; // Min distance from screen edge

                // 1. Try to center relative to the target
                let finalX = targetGlobalX + (targetW - popupW) / 2;

                // 2. Clamp left edge
                if (finalX < marginOffset)
                    finalX = marginOffset;

                // 3. Clamp right edge
                if (finalX + popupW > screenW - marginOffset)
                    finalX = screenW - popupW - marginOffset;

                return finalX;
            }
        }

        // === Background & Content ===
        Rectangle {
            id: bg

            // Auto-size based on content + padding
            implicitWidth: (root.contentItem?.implicitWidth ?? 0) + root.padding * 2
            implicitHeight: (root.contentItem?.implicitHeight ?? 0) + root.padding * 2

            color: Colors.palette.m3surfaceContainer
            radius: root.radius

            border {
                width: 1
                color: Colors.palette.m3surfaceContainerHigh
            }

            // Inject content
            children: root.contentItem ? [root.contentItem] : []

            // Position content with padding
            onChildrenChanged: {
                if (root.contentItem) {
                    root.contentItem.x = root.padding;
                    root.contentItem.y = root.padding;
                }
            }
        }
    }
}
