import { Astal, Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import Workspaces from "./modules/workspaces/Workspaces";
import FocusedClient from "./modules/focusedclient/FocusedClient";
import Clock from "./modules/clock/Clock";
import Tray from "./modules/tray/Tray";
import KbLayout from "./modules/kblayout/KbLayout";
import SysButton from "./modules/sysbutton/SysButton";
import Battery from "./modules/battery/Battery";
import { options } from "../../lib/settings";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM, RIGHT, LEFT } = Astal.WindowAnchor;

  const barTop = options.bar.top;

  const anchor = barTop.value ? TOP | RIGHT | LEFT : BOTTOM | RIGHT | LEFT;

  return (
    <window
      visible
      anchor={anchor}
      name={"bar"}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={app}
    >
      <centerbox>
        <box $type="start" hexpand class="left-side" spacing={16}>
          <Workspaces />
          <FocusedClient />
        </box>
        <box $type="center" class="center" spacing={8}>
          <Clock />
        </box>
        <box $type="end" class="right-side" spacing={8}>
          <Tray />
          <KbLayout />
          <SysButton />
          <Battery />
        </box>
      </centerbox>
    </window>
  );
}
