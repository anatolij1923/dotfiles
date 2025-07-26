import Wp from "gi://AstalWp";
import QSButton from "../../QSButton";
import Notifd from "gi://AstalNotifd";
import {
  createBinding,
  createComputed,
  createExternal,
  createState,
} from "ags";
import Network from "gi://AstalNetwork";
import Bluetooth from "gi://AstalBluetooth";
import { Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";

function WifiButton() {
  const wifi = Network.get_default().wifi;

  const state = createBinding(wifi, "state");
  const ssid = createBinding(wifi, "ssid");
  const wifiName = createComputed([state, ssid], (state, ssid) =>
    state === Network.DeviceState.ACTIVATED ? ssid : "Wi-Fi"
  );

  return (
    <QSButton
      connection={[wifi, "enabled"]}
      onClicked={() => wifi.set_enabled(!wifi.get_enabled())}
      iconName={createBinding(
        wifi,
        "enabled"
      )((v) => (v ? "network_wifi" : "signal_wifi_off"))}
      tooltip="Click to enable or disable wifi"
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
      tooltip="Click to enable or disable bluetooth. Right click to open blueman"
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
      tooltip="Click to mute or unmute mic"
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
      tooltip="Click to change DND mode"
    />
  );
}
function NightLight() {
  return <QSButton iconName="bedtime" />;
}

function IdleInhibitor() {
  return <QSButton iconName="coffee" />;
}

export default function Toggles() {
  return (
    <centerbox class="toggles" halign={Gtk.Align.CENTER}>
      <box $type="center" spacing={8}>
        <WifiButton />
        <BluetoothButton />
        <NightLight />
        <DND />
        <Mic />
        <IdleInhibitor />
      </box>
    </centerbox>
  );
}
