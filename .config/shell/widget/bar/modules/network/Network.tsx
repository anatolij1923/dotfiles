import { createBinding, createComputed } from "ags";
import AstalNetwork from "gi://AstalNetwork?version=0.1";

export default function Network() {
  const net = AstalNetwork.get_default();

  const primaryConnectionType = createBinding(net, "primary");

  const wifiEnabled = createBinding(net.wifi, "enabled");
  const wifiSsid = createBinding(net.wifi, "ssid")

  const networkState = createBinding(net.wired, "state");

  const icon = createComputed(
    [primaryConnectionType, wifiEnabled, networkState],
    (primaryType, wifi, state) => {
      if (primaryType === AstalNetwork.Primary.WIRED) {
        return "lan";
      }

      if (
        primaryType === AstalNetwork.Primary.WIFI ||
        (wifi && primaryType === AstalNetwork.Primary.UNKNOWN)
      ) {
        return "network_wifi";
      }

      if (
        state === AstalNetwork.State.DISCONNECTED ||
        state === AstalNetwork.State.DISCONNECTING
      ) {
        return "signal_wifi_off";
      }

      return "signal_wifi_off";
    },
  );

  return (
    <box class="network">
      <label label={icon} class="material-icon" />
    </box>
  );
}
