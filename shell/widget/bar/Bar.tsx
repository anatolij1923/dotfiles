import { Astal, Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import Clock from "./modules/clock/Clock";
import KbLayout from "./modules/kblayout/KbLayout";
import FocusedClient from "./modules/focusedclient/FocusedClient";
import Battery from "./modules/battery/Battery";
import Tray from "./modules/tray/Tray";
import Workspaces from "./modules/workspaces/Workspaces";
import BluetoothWidget from "./modules/bluetoothWidget/bluetoothWidget";
import Test from "../osd/OSD";
import Wifi from "./modules/wifi/Wifi";

function CommonButton() {
  return (
    <box class="common-button">
      <button
        onClicked={() => {
          app.toggle_window("quicksettings");
        }}
      >
        <box spacing={16}>
          <Wifi />
          <BluetoothWidget />
          <Battery />
        </box>
      </button>
    </box>
  );
}

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
        <box $type="start" class="left-side" spacing={8}>
          <FocusedClient />
        </box>
        <box $type="center" class="center" spacing={8}>
          <Workspaces />
        </box>
        <box $type="end" class="right-side" spacing={8}>
          <Tray />
          {/* <BluetoothWidget /> */}
          <KbLayout />
          {/* <Battery /> */}
          <CommonButton />
          <Clock />
        </box>
      </centerbox>
    </window>
  );
}
