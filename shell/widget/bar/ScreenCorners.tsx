import { Astal, Gdk } from "ags/gtk4";

export function ScreenCorners(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM } = Astal.WindowAnchor;
  return (
    <window
      class="screen-corner"
      name={"screen-corner"}
      namespace={"ScreenCorners"}
      gdkmonitor={gdkmonitor}
      anchor={TOP}
      keymode={Astal.Keymode.ON_DEMAND}
      layer={Astal.Layer.BOTTOM}
      widthRequest={1920}
      heightRequest={22}
      visible
    >
      <box cssClasses={["shadow"]} vexpand hexpand>
        <box cssClasses={["border"]} vexpand hexpand>
          <box cssClasses={["corner"]} vexpand hexpand />
        </box>
      </box>
    </window>
  );
}
