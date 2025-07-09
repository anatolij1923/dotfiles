import Wp from "gi://AstalWp";
import QSButton from "../../QSButton";
import Notifd from "gi://AstalNotifd";
import { createBinding } from "ags";
import Network from "gi://AstalNetwork";
import Bluetooth from "gi://AstalBluetooth";

function WifiButton() {
  const wifi = Network.get_default().wifi;

  return (
    <QSButton
      connection={[wifi, "enabled"]}
      onClicked={() => wifi.set_enabled(!wifi.get_enabled())}
      iconName={createBinding(
        wifi,
        "enabled"
      )((v) => (v ? "network_wifi" : "signal_wifi_off"))}
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
        "isPowered"
      )((v) => (v ? "bluetooth" : "bluetooth_disabled"))}
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
        "mute"
      )((v) => (v ? "mic_off" : "mic"))}
      // label={"mix"}
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
        "dontDisturb" // Changed to camelCase
      )((dnd) => (dnd ? "notifications_off" : "notifications"))}
    />
  );
}

export default function Toggles() {
  return (
    <box>
      <WifiButton />
      <BluetoothButton />
      <Mic />
      <DND />
    </box>
  );
}
