import { Astal, Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import Clock from "./modules/clock/Clock";
import KbLayout from "./modules/kblayout/KbLayout";
import FocusedClient from "./modules/focusedclient/FocusedClient";
import Battery from "./modules/battery/Battery";
import Tray from "./modules/tray/Tray";
import Workspaces from "./modules/workspaces/Workspaces";
import BluetoothWidget from "./modules/bluetoothWidget/bluetoothWidget";
import Wifi from "./modules/wifi/Wifi";
import NotificationWidget from "./modules/notificationWidget/NotifiicationWidget";
import { onCleanup } from "ags";

function CommonButton() {
  return (
    <box
      class="common-button"
      $={(self) => {
        const appconnect = app.connect("window-toggled", (_, win) => {
          if (win.name !== "quicksettings") return;
          const visible = win.visible;
          self[visible ? "add_css_class" : "remove_css_class"]("active");
        });
        onCleanup(() => app.disconnect(appconnect));
      }}
    >
      <button
        onClicked={() => {
          app.toggle_window("quicksettings");
        }}
      >
        <box spacing={16}>
          <NotificationWidget />
          <Wifi />
          <BluetoothWidget />
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
          <CommonButton />
          <Battery />
        </box>
      </centerbox>
    </window>
  );
}
