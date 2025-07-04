import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";
import AstalBluetooth from "gi://AstalBluetooth?version=0.1";

const bt = AstalBluetooth.get_default();

const deviceInfo = createPoll(
  { connected: false, battery: 0, name: "" },
  4000,
  () => {
    const dev = bt.devices.find((d) => d.connected);
    if (dev) {
      return {
        connected: true,
        battery: dev.battery_percentage,
        name: dev.name,
      };
    } else {
      return { connected: false, battery: 0, name: "" };
    }
  },
);

export default function BluetoothWidget() {

  const tooltip = (deviceInfo((di => `${di.name} - ${di.battery*100}%`)))

  return (
    <box
      visible={deviceInfo((di) => di.connected)}
      class="bluetooth-widget"
      tooltipText={tooltip}
      spacing={0}
    >
      <label label={"bluetooth"} class="material-icon" />
      <levelbar
        value={deviceInfo((di) => di.battery)}
        orientation={Gtk.Orientation.VERTICAL}
      />
    </box>
  );
}
