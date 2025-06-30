import { Astal, Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import Clock from "./modules/clock/Clock";
import KbLayout from "./modules/kblayout/KbLayout";
import FocusedClient from "./modules/focusedclient/FocusedClient";
import Battery from "./modules/battery/Battery";
import Tray from "./modules/tray/Tray";
import Workspaces from "./modules/workspaces/Workspaces";
import BluetoothWidget from "./modules/bluetoothWidget/bluetoothWidget";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, RIGHT, LEFT } = Astal.WindowAnchor;

  return (
    <window
      visible
      anchor={TOP | RIGHT | LEFT}
      name={"bar"}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={app}
    >
      <centerbox>
        <box $type="start" class="left-side" spacing={16}>
          <FocusedClient />
        </box>
        <box $type="center" class="center" spacing={16} >
          <Workspaces />
          <KbLayout />
        </box>
        <box $type="end" class="right-side" spacing={16}>
          <Tray />
          <BluetoothWidget />
          <Battery />
          <Clock />
        </box>
      </centerbox>
    </window>
  );
}
