import QtQuick
import qs.services

Canvas {
    id: root
    property real amplitudeMultiplier: 0.5
    property real frequency: 6
    property color color: Colors.palette.m3primary
    property real lineWidth: 4
    property real fullLength: width

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset(); 
        ctx.clearRect(0, 0, width, height);

        if (width <= 0 || root.fullLength <= 0) return; 

        var amplitude = root.lineWidth * root.amplitudeMultiplier;
        var frequency = root.frequency;
        var phase = Date.now() / 400.0;
        var centerY = height / 2;

        ctx.strokeStyle = root.color;
        ctx.lineWidth = root.lineWidth;
        ctx.lineCap = "round";
        ctx.lineJoin = "round";
        
        ctx.beginPath();
        
        var first = true;
        for (var x = 0; x <= width; x += 1) {
            var waveY = centerY + amplitude * Math.sin(frequency * 2 * Math.PI * x / Math.max(1, root.fullLength) + phase);
            
            if (first) {
                ctx.moveTo(x, waveY);
                first = false;
            } else {
                ctx.lineTo(x, waveY);
            }
        }
        ctx.stroke();
    }
}
