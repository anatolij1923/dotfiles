import { Astal, Gdk } from "ags/gtk4";
import cairo from "gi://cairo?version=1.0";

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
      layer={Astal.Layer.TOP}
      heightRequest={22}
      visible
      hexpand
      $={(win) => {
        const surface = win.get_surface();
        surface?.set_input_region(new cairo.Region());

        win.connect("map", () => {
          win.get_surface()?.set_input_region(new cairo.Region());
        });
      }}
    >
      <box cssClasses={["shadow"]} vexpand hexpand>
        <box cssClasses={["border"]} vexpand hexpand>
          <box cssClasses={["corner"]} vexpand hexpand />
        </box>
      </box>
    </window>
  );
}
