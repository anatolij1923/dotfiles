import Wp from "gi://AstalWp";
import QSButton from "../../QSButton";
import Notifd from "gi://AstalNotifd";
import { createBinding, createComputed, createState } from "ags";
import Network from "gi://AstalNetwork";
import Bluetooth from "gi://AstalBluetooth";
import { Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";

function WifiButton() {
  const wifi = Network.get_default().wifi;

  const state = createBinding(wifi, "state")
  const ssid = createBinding(wifi, "ssid")
  const wifiName = createComputed([state, ssid], (state, ssid) => 
    state === Network.DeviceState.ACTIVATED ? ssid : "Wi-Fu"
  )

  return (
    <QSButton
      connection={[wifi, "enabled"]}
      onClicked={() => wifi.set_enabled(!wifi.get_enabled())}
      iconName={createBinding(
        wifi,
        "enabled",
      )((v) => (v ? "network_wifi" : "signal_wifi_off"))}
      label={wifiName}
    />

  );
}

function BluetoothButton() {
  const bluetooth = Bluetooth.get_default();

  return (
    <QSButton
      connection={[bluetooth, "isPowered"]} // Changed to camelCase
      onClicked={() => bluetooth.toggle()}
      iconName={createBinding(
        bluetooth,
        "isPowered",
      )((v) => (v ? "bluetooth" : "bluetooth_disabled"))}
      label={createBinding(bluetooth, "isConnected").as((connected) => {
        if (connected) {
          const device = bluetooth.devices.find((d) => d.connected);
          if (device) {
            return device.name;
          } else {
            return "Bluetooth";
          }
        } else {
          return "Bluetooth";
        }
      })}
    />
  );
}

function Mic() {
  const wp = Wp.get_default();
  return (
    <QSButton
      connection={[wp?.defaultMicrophone, "mute"]}
      onClicked={() => {
        const mute = wp?.defaultMicrophone.mute;
        wp?.defaultMicrophone.set_mute(!mute);
      }}
      iconName={createBinding(
        wp?.defaultMicrophone,
        "mute",
      )((v) => (v ? "mic_off" : "mic"))}
      label={createBinding(wp?.defaultMicrophone, "mute")((v) => v ? "Muted" : "Unmuted")}
    />
  );
}

function DND() {
  const notifd = Notifd.get_default();

  return (
    <QSButton
      connection={[notifd, "dontDisturb", (v) => v]} // Changed to camelCase
      onClicked={() => {
        notifd.set_dont_disturb(!notifd.get_dont_disturb());
      }}
      iconName={createBinding(
        notifd,
        "dontDisturb", // Changed to camelCase
      )((dnd) => (dnd ? "notifications_off" : "notifications"))}
      label={createBinding(notifd, "dontDisturb")((v) => v ? "Silent" : "Noisy")}
    />
  );
}

export default function Toggles() {
  return (
    <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
        <box homogeneous>
          <WifiButton />
          <BluetoothButton />
        </box>
        <box homogeneous>
          <Mic />
          <DND />
        </box>
    </box>
  );
}
