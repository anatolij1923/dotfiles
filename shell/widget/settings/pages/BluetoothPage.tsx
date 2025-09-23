import { createBinding, For } from "ags";
import SettingsPage from "./SettingsPage";
import AstalBluetooth from "gi://AstalBluetooth?version=0.1";
import { Gtk } from "ags/gtk4";
import { SwitchRow } from "../controls/SwitchRow";

function toggleDevice(device: Bluetooth.Device) {
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
                <label label={device.name} />
                <box hexpand />
                <button class="connect-button" onClicked={() => toggleDevice(device)}>
                  <label label="link" class="material-icon" />
                </button>
              </box>
            )}
          </For>
        </box>
      </Gtk.ScrolledWindow>
    </SettingsPage>
  );
}
