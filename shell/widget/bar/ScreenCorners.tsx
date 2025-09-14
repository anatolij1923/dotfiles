import { Astal, Gdk } from "ags/gtk4";
import cairo from "gi://cairo?version=1.0";
import { options } from "../../lib/settings";

export function ScreenCorners(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

  const cornersEnabled = options.corners.enabled.value;
  if (!cornersEnabled) return null;

  // Верхние углы
  const topCorners = (
    <window
      class="screen-corner top"
      name="screen-corner-top"
      gdkmonitor={gdkmonitor}
      anchor={TOP | LEFT | RIGHT}
      visible={options.bar.top.value} 
      hexpand
      heightRequest={22}
    >
      <box cssClasses={["shadow"]} vexpand hexpand>
        <box cssClasses={["border"]} vexpand hexpand>
          <box cssClasses={["corner"]} vexpand hexpand />
        </box>
      </box>
    </window>
  );

  const bottomCorners = (
    <window
      class="screen-corner bottom"
      name="screen-corner-bottom"
      gdkmonitor={gdkmonitor}
      anchor={BOTTOM | LEFT | RIGHT}
      visible={!options.bar.top.value} 
      hexpand
      heightRequest={22}
    >
      <box cssClasses={["shadow"]} vexpand hexpand>
        <box cssClasses={["border"]} vexpand hexpand>
          <box cssClasses={["corner"]} vexpand hexpand />
        </box>
      </box>
    </window>
  );

  // подписка на изменение положения бара

  return [topCorners, bottomCorners];
}

