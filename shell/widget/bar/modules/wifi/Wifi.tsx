import { createBinding } from "ags";
import Network from "gi://AstalNetwork";

export default function Wifi() {
  const wifi = Network.get_default().wifi;

  // const icon = () => {
  //   const isEnabled = createBinding(wifi, "enabled");
  //   const isConnected = createBinding(wifi, "ssid");

  //   if (isEnabled.get()) {
  //     return "wifi";
  //   } else return "signal_wifi_off";
  // };

  const icon = createBinding(
    wifi,
    "enabled"
  )((v) => (v ? "network_wifi" : "signal_wifi_off"));

  return (
    <box class="wifi">
      <label label={icon} class="material-icon" />
    </box>
  );
}
