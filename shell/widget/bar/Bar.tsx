import { Astal, Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import Workspaces from "./modules/workspaces/Workspaces";
import FocusedClient from "./modules/focusedclient/FocusedClient";
import Clock from "./modules/clock/Clock";
import Tray from "./modules/tray/Tray";
import KbLayout from "./modules/kblayout/KbLayout";
import SysButton from "./modules/sysbutton/SysButton";
import Battery from "./modules/battery/Battery";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM, RIGHT, LEFT } = Astal.WindowAnchor;

  return (
    <window
      visible
      anchor={TOP | LEFT | RIGHT}
      name={"bar"}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={app}
    >
      <centerbox class="bar">
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
