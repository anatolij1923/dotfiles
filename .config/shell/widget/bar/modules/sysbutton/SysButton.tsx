import { onCleanup } from "ags";
import app from "ags/gtk4/app";
import NotificationWidget from "../notificationWidget/NotificationWidget";
import BluetoothWidget from "../bluetoothWidget/bluetoothWidget";
import NetworkWidget from "../network/Network";

export default function SysButton() {
  return (
    <box
      class="sys-button"
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
          <NetworkWidget />
          <BluetoothWidget />
        </box>
      </button>
    </box>
  );
}

