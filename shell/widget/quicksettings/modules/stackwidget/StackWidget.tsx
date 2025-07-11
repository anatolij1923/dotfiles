import { Gtk } from "ags/gtk4";
import { createState } from "ags"; // Removed createBinding as it's not used directly with Accessor
import NotificationWindow from "../notificationwindow/NotificationWindow";
import BluetoothDevices from "../bluetoothdevices/BluetoothDevices";
import WifiAccessPoints from "../wifi/WifiAccessPoints";

export default function StackWidget() {
  const [activeStackChild, setActiveStackChild] = createState("notifications");

  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="stack-widget">
      <box class="buttons" halign={Gtk.Align.CENTER} spacing={8}>
        <button
          class={activeStackChild.as((v) =>
            v === "notifications" ? "active" : ""
          )}
          onClicked={() => setActiveStackChild("notifications")}
        >
          <box spacing={8}>
            <label label="notifications" class="material-icon" />
            <label
              label="Notifications"
              visible={activeStackChild.as((v) => v === "notifications")}
            />
          </box>
        </button>
        <button
          class={activeStackChild.as((v) =>
            v === "bluetooth-devices" ? "active" : ""
          )}
          onClicked={() => setActiveStackChild("bluetooth-devices")}
        >
          <box spacing={8}>
            <label label="bluetooth" class="material-icon" />
            <label
              label="Bluetooth"
              visible={activeStackChild.as((v) => v === "bluetooth-devices")}
            />
          </box>
        </button>
        <button
          class={activeStackChild.as((v) => (v === "wifi-aps" ? "active" : ""))}
          onClicked={() => setActiveStackChild("wifi-aps")}
        >
          <box spacing={8}>
            <label label="wifi" class="material-icon" />
            <label
              label="Wi-Fi"
              visible={activeStackChild.as((v) => v === "wifi-aps")}
            />
          </box>
        </button>
      </box>
      <stack
        visibleChildName={activeStackChild}
        transitionType={Gtk.StackTransitionType.SLIDE_LEFT}
      >
        <box $type="named" name="notifications">
          <NotificationWindow />
        </box>
        <box $type="named" name="bluetooth-devices">
          <BluetoothDevices />
        </box>
        <box $type="named" name="wifi-aps">
          <WifiAccessPoints />
        </box>
      </stack>
    </box>
  );
}
