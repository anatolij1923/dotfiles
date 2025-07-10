import { createBinding, For } from "ags";
import { Gtk } from "ags/gtk4";
import Bluetooth from "gi://AstalBluetooth";

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

function getBatteryPercentage(device: Bluetooth.Device) {
  const batteryPercent = createBinding(device, "batteryPercentage");
  const formattedPercentage = batteryPercent.as(
    (bp) => `${Math.floor(bp * 100)}%`
  );
  return formattedPercentage;
}

export default function BluetoothDevices() {
  const bluetooth = Bluetooth.get_default();

  return (
    <box
      name={"bluetooth-devices"}
      orientation={Gtk.Orientation.VERTICAL}
      class="bluetooth-devices"
    >
      <Gtk.ScrolledWindow>
        <For each={createBinding(bluetooth, "devices")}>
          {(device: Bluetooth.Device) => (
            <button
              onClicked={() => toggleDevice(device)}
              class={createBinding(device, "connected").as((c) =>
                c ? "device-button active" : "device-button"
              )}
            >
              <box hexpand>
                <label label={device.name} />
                <box hexpand />
                <label
                  visible={createBinding(device, "connected")}
                  label={getBatteryPercentage(device)}
                />
              </box>
            </button>
          )}
        </For>
      </Gtk.ScrolledWindow>
    </box>
  );
}
