// https://www.youtube.com/watch?v=sqcHd4tI99Y&t=499s
import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.services

Scope {

    PanelWindow {
        id: root
        // anchors {
        //     right: true
        //     top: true
        //     bottom: true
        //     left: true
        // }
        exclusiveZone: 0
        color: "transparent"

        visible: GlobalStates.titOpened

        implicitWidth: 600
        implicitHeight: 600
        property real dpr: 1
        property real zoom: 4.0
        property real t: 0.66
        property real animSpeed: 0.075
        // pan offsets in pixels (applied to the rendered plot)
        property real panXpx: 0
        property real panYpx: 0

        FrameAnimation {
            running: true
            onTriggered: {
                root.t = (root.t + root.animSpeed) % (2 * Math.PI);
                funcCanvas.requestPaint();
            }
        }

        Rectangle {
            anchors {
                fill: parent
                margins: 10
            }
            color: Colors.palette.m3surfaceContainer
            radius: 20
            border.width: 1
            border.color: Colors.palette.m3surfaceContainerHighest

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 5
                }
                renderType: Text.NativeRendering
                font.pixelSize: 16
                text: "мощни сискэ"
                color: Colors.palette.m3onSurface
            }

            /* --- Begin Add stuff here --- */
            Canvas {
                id: funcCanvas
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    // push below the title
                    topMargin: 40
                    bottom: parent.bottom
                    bottomMargin: 10
                }
                // simple crisp drawing on high-dpi
                // Qt.application.devicePixelRatio is not always available; use a safe default.
                // Change to a runtime query of screen/device pixel ratio if your platform exposes it.
                property real dpr: root.dpr
                property real zoom: root.zoom
                // bind pan offsets from root (pixel units)
                property real panXpx: root.panXpx
                property real panYpx: root.panYpx

                onPaint: {
                    var ctx = getContext("2d");
                    var w = width, h = height;
                    // scale for devicePixelRatio for sharper lines on HiDPI
                    if (funcCanvas.width !== Math.round(w * dpr) || funcCanvas.height !== Math.round(h * dpr)) {
                        funcCanvas.width = Math.round(w * dpr);
                        funcCanvas.height = Math.round(h * dpr);
                        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
                    }

                    // clear before rotating the context
                    ctx.clearRect(0, 0, w, h);

                    // rotate coordinate system -90 degrees (counterclockwise)
                    ctx.save();
                    ctx.translate(0, h);
                    ctx.rotate(-Math.PI / 2);

                    // after rotation: treat effective drawing area as tw x th (tw = original height)
                    var tw = h, th = w;

                    // background (subtle)
                    ctx.fillStyle = "rgba(0,0,0,0)";
                    ctx.fillRect(0, 0, tw, th);

                    // https://github.com/UdonDa/OppaiFunction/blob/master/Untitled.ipynb
                    // def nagoya_yure(x, t):
                    //     y_1 = (1.5 * np.exp((0.12*np.sin(t) - 0.5) * (x + 0.16*np.sin(t)) ** 2)) /  (1 + np.exp((-1) * 20 * (5*x + np.sin(t))))
                    //     y_2 = (1.5 + 0.8 * (x + 0.2*np.sin(t))**3) * (1 + np.exp(20 * (5*x + np.sin(t)))) ** (-1) / (1 + np.exp(-1 * (100 * (x + 1) + 16 * np.sin(t))))
                    //     y_3 = (0.2 * (1 + np.exp(-1*(x+1)**2))) / (1 + np.exp(100*(x+1) + 16*np.sin(t)))
                    //     y_4 = 0.1 / (np.exp((2*(10*x + 1.2*(2+np.sin(t)) * np.sin(t))) ** 4))
                    const nagoyaYure = (x, t) => {
                        const y1 = (1.5 * Math.exp((0.12 * Math.sin(t) - 0.5) * (x + 0.16 * Math.sin(t)) ** 2)) / (1 + Math.exp((-1) * 20 * (5 * x + Math.sin(t))));
                        const y2 = ((1.5 + 0.8 * (x + 0.2 * Math.sin(t)) ** 3) * (1 + Math.exp(20 * (5 * x + Math.sin(t)))) ** (-1)) / (1 + Math.exp(-1 * (100 * (x + 1) + 16 * Math.sin(t))));
                        const y3 = (0.2 * (1 + Math.exp(-1 * (x + 1) ** 2))) / (1 + Math.exp(100 * (x + 1) + 16 * Math.sin(t)));
                        const y4 = 0.1 / (Math.exp((2 * (10 * x + 1.2 * (2 + Math.sin(t)) * Math.sin(t))) ** 4));
                        return y1 + y2 + y3 + y4;
                    };
                    function f(x) {
                        return nagoyaYure(x, root.t);
                    }

                    // choose base x range (math coords) and apply zoom
                    var xMinBase = -10, xMaxBase = 10;
                    var centerX = (xMinBase + xMaxBase) / 2;
                    var halfRangeBase = (xMaxBase - xMinBase) / 2;
                    var halfRangeZoomed = halfRangeBase / zoom;
                    var xMin = centerX - halfRangeZoomed;
                    var xMax = centerX + halfRangeZoomed;

                    // sample to find y range
                    var samples = 200;
                    var yMin = Infinity, yMax = -Infinity;
                    for (var i = 0; i <= samples; ++i) {
                        var x = xMin + (xMax - xMin) * (i / samples);
                        var y = f(x);
                        if (y < yMin)
                            yMin = y;
                        if (y > yMax)
                            yMax = y;
                    }
                    // padding
                    var yPad = (yMax - yMin) * 0.1;
                    if (!isFinite(yPad) || yPad === 0)
                        yPad = 1;
                    yMin -= yPad;
                    yMax += yPad;

                    // preserve aspect ratio using tw/th (swapped dims)
                    var scaleX = tw / (xMax - xMin);
                    var scaleY = th / (yMax - yMin);
                    var scale = Math.min(scaleX, scaleY);

                    var drawW = scale * (xMax - xMin);
                    var drawH = scale * (yMax - yMin);
                    var offsetX = (tw - drawW) / 2;
                    var offsetY = (th - drawH) / 2;

                    // mapping math coords -> pixel coords in rotated coord system
                    // include panXpx / panYpx (pixel offsets applied after math->pixel mapping)
                    function mapX(x) {
                        return offsetX + (x - xMin) * scale + panXpx;
                    }
                    function mapY(y) {
                        return th - (offsetY + (y - yMin) * scale) + panYpx;
                    }
                    // --- End aspect-ratio fix ---

                    // draw axes (use tw/th)
                    ctx.lineWidth = 1;
                    ctx.strokeStyle = Colors.palette.m3onSurface;
                    if (0 >= yMin && 0 <= yMax) {
                        var y0 = mapY(0);
                        ctx.beginPath();
                        ctx.moveTo(0, y0);
                        ctx.lineTo(tw, y0);
                        ctx.stroke();
                    }
                    if (0 >= xMin && 0 <= xMax) {
                        var x0 = mapX(0);
                        ctx.beginPath();
                        ctx.moveTo(x0, 0);
                        ctx.lineTo(x0, th);
                        ctx.stroke();
                    }

                    // draw the function curve using the same mapping and tw as effective width
                    ctx.strokeStyle = Colors.palette.m3primary;
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    var first = true;
                    for (var px = 0; px <= tw; px++) {
                        var t = px / tw;
                        var x = xMin + (xMax - xMin) * t;
                        var y = f(x);
                        var pxm = mapX(x);
                        var py = mapY(y);
                        if (first) {
                            ctx.moveTo(pxm, py);
                            first = false;
                        } else
                            ctx.lineTo(pxm, py);
                    }
                    ctx.stroke();

                    // restore original (unrotated) context
                    ctx.restore();
                }

                // repaint on resize
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }
            /* --- End Add stuff here --- */
            // MouseArea placed after Canvas so it receives mouse input and can pan/zoom
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                property real lastX: 0
                property real lastY: 0
                onPressed: {
                    lastX = mouseArea.mouseX;
                    lastY = mouseArea.mouseY;
                }
                onPositionChanged: mouse => {
                    if (mouse.buttons & Qt.LeftButton) {
                        var dx = mouse.x - lastX;
                        var dy = mouse.y - lastY;
                        lastX = mouse.x;
                        lastY = mouse.y;
                        root.panXpx += -dy;
                        root.panYpx += dx;
                        funcCanvas.requestPaint();
                    }
                }
                onWheel: wheel => {
                    if (wheel.angleDelta.y > 0) {
                        root.zoom *= 1.1;
                    } else if (wheel.angleDelta.y < 0) {
                        root.zoom /= 1.1;
                    }
                    if (root.zoom < 0.1)
                        root.zoom = 0.1;
                    funcCanvas.requestPaint();
                }
            }
        }
    }

    IpcHandler {
        target: "tit"

        function toggle(): void {
            GlobalStates.titOpened = !GlobalStates.titOpened;
        }
    }
}
