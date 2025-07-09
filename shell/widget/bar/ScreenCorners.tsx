import { Astal, Gdk } from "ags/gtk4";

export function ScreenCorners(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      class="screen-corner"
      name={"screen-corner"}
      namespace={"ScreenCorners"}
      gdkmonitor={gdkmonitor}
      anchor={TOP | LEFT | RIGHT}
      keymode={Astal.Keymode.NONE}
      layer={Astal.Layer.BOTTOM}
      heightRequest={22}
      visible
      hexpand
    >
      <box cssClasses={["shadow"]} vexpand hexpand>
        <box cssClasses={["border"]} vexpand hexpand>
          <box cssClasses={["corner"]} vexpand hexpand />
        </box>
      </box>
    </window>
  );
}
