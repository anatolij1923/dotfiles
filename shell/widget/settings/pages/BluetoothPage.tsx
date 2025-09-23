import { createBinding, For } from "ags";
import SettingsPage from "./SettingsPage";
import AstalBluetooth from "gi://AstalBluetooth?version=0.1";
import { Gtk } from "ags/gtk4";
import { SwitchRow } from "../controls/SwitchRow";

const matreialDeviceIcons: Record<string, string> = {
  "audio-headset": "headphones",
  laptop: "laptop",
  watch: "watch",
};

function toggleDevice(device: AstalBluetooth.Device) {
  if (!device.paired) {
    device.trusted = true;
    device.pair();
    device.connect_device(null);
  } else if (!device.connected) {
    device.connect_device(null);
  } else if (device.connected) {
    device.disconnect_device(null);
  }
}

function devicePercentage(device: AstalBluetooth.Device) {
  const percentage = createBinding(device, "batteryPercentage");
  return `${percentage.get() * 100}%`;
}

export default function BluetoothPage() {
  const bluetooth = AstalBluetooth.get_default();
  const bluetoothEnabled = createBinding(bluetooth, "is_powered");

  return (
    <SettingsPage className="bluetooth-page" headerTitle="Bluetooth">
      <box>
        <SwitchRow
          label="Bluetooth"
          value={bluetoothEnabled}
          onChange={() => bluetooth.toggle()}
        />

        {/* <button class="search-button"> */}
        {/*   <label label="search" class="material-icon" /> */}
        {/* </button> */}
      </box>
      <Gtk.ScrolledWindow vexpand>
        <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
          <For each={createBinding(bluetooth, "devices")}>
            {(device: AstalBluetooth.Device) => (
              <box class="bluetooth-device">
                <box class="device-info" spacing={16}>
                  <box
                    class={createBinding(
                      device,
                      "connected",
                    )((c) => (c ? "device-icon connected" : "device-icon"))}
                  >
                    <label
                      label={matreialDeviceIcons[device.icon] || "devices"}
                      class="material-icon"
                    />
                  </box>
                  <box
                    class="device-name"
                    orientation={Gtk.Orientation.VERTICAL}
                  >
                    <label label={device.name} class="name" xalign={0} />
                    <label
                      label={createBinding(
                        device,
                        "connected",
                      )((c) =>
                        c
                          ? `Connected - ${devicePercentage(device)}`
                          : device.address,
                      )}
                      class="address"
                      xalign={0}
                    />
                  </box>
                </box>
                <box hexpand />
                <box class="connect-button">
                  <button onClicked={() => toggleDevice(device)}>
                    <label label="link" class="material-icon" />
                  </button>
                </box>
              </box>
            )}
          </For>
        </box>
      </Gtk.ScrolledWindow>
    </SettingsPage>
  );
}
