import { Gtk } from "ags/gtk4";
import Cairo from "gi://cairo";

export interface CircularProgressProps {
  percentage?: number; // от 0 до 1
  size?: number; // размер в пикселях
  lineWidth?: number; // ширина линии
  foregroundColor?: string; // цвет прогресса (hex или rgba)
  backgroundColor?: string; // цвет фона (hex или rgba)
  showBackground?: boolean; // показывать ли фон
}

function parseColor(color: string | undefined, fallback = "#ffffff") {
  color ??= fallback;
  if (color.startsWith("#") && color.length === 7) {
    const r = parseInt(color.slice(1, 3), 16) / 255;
    const g = parseInt(color.slice(3, 5), 16) / 255;
    const b = parseInt(color.slice(5, 7), 16) / 255;
    return { r, g, b, a: 1 };
  }
  const rgba = color.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)/);
  if (rgba) {
    const [, r, g, b, a] = rgba;
    return {
      r: parseInt(r) / 255,
      g: parseInt(g) / 255,
      b: parseInt(b) / 255,
      a: a ? parseFloat(a) : 1,
    };
  }
  return { r: 1, g: 1, b: 1, a: 1 };
}

export const CircularProgress = ({
  percentage = 0,
  size = 24,
  lineWidth = 2,
  foregroundColor = "#ffffff",
  backgroundColor = "#ff00ff00",
  showBackground = true,
}: CircularProgressProps) => {
  const widget = new Gtk.DrawingArea();

  widget.set_size_request(size, size);

  widget.set_draw_func((area, cr, width, height) => {
    const centerX = width / 2;
    const centerY = height / 2;
    const radius = Math.min(width, height) / 2 - lineWidth / 2;
    const startAngle = -Math.PI / 2;
    const endAngle = startAngle + percentage * 2 * Math.PI;

    // Очистка
    cr.save();
    cr.setOperator(Cairo.Operator.CLEAR);
    cr.paint();
    cr.restore();

    cr.setOperator(Cairo.Operator.OVER);

    // Фон
    if (showBackground) {
      const bg = parseColor(backgroundColor);
      cr.setSourceRGBA(bg.r, bg.g, bg.b, bg.a);
      cr.setLineWidth(lineWidth);
      cr.arc(centerX, centerY, radius, 0, 2 * Math.PI);
      cr.stroke();
    }

    // Прогресс
    if (percentage > 0.001) {
      const fg = parseColor(foregroundColor);
      cr.setSourceRGBA(fg.r, fg.g, fg.b, fg.a);
      cr.setLineWidth(lineWidth);
      cr.arc(centerX, centerY, radius, startAngle, endAngle);
      cr.stroke();
    }
  });

  return widget;
};

export default CircularProgress;
