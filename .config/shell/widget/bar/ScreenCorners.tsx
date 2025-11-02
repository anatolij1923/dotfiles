import { Astal, Gdk } from "ags/gtk4";
import cairo from "gi://cairo?version=1.0";

export function ScreenCorners(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

  const topCorners = (
    <window
      class="screen-corner top"
      name="screen-corner-top"
      gdkmonitor={gdkmonitor}
      anchor={TOP | LEFT | RIGHT}
      visible
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

  return [topCorners, bottomCorners];
}

