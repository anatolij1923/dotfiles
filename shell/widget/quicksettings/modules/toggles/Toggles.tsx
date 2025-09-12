import Wp from "gi://AstalWp";
import QSButton from "../../QSButton";
import Notifd from "gi://AstalNotifd";
import {
  Accessor,
  createBinding,
  createComputed,
  createExternal,
  createState,
} from "ags";
import Network from "gi://AstalNetwork";
import Bluetooth from "gi://AstalBluetooth";
import { Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";
import AstalPowerProfiles from "gi://AstalPowerProfiles";

function WifiButton() {
  const wifi = Network.get_default().wifi;

  const state = createBinding(wifi, "state");
  const ssid = createBinding(wifi, "ssid");
  const wifiName = createComputed([state, ssid], (state, ssid) =>
    state === Network.DeviceState.ACTIVATED ? ssid : "Wi-Fi",
  );

  return (
    <QSButton
      connection={[wifi, "enabled"]}
      onClicked={() => wifi.set_enabled(!wifi.get_enabled())}
      iconName={createBinding(
        wifi,
        "enabled",
      )((v: boolean) => (v ? "network_wifi" : "signal_wifi_off"))}
      tooltip="Click to enable or disable Wi-Fi"
    />
  );
}

function BluetoothButton() {
  const bluetooth = Bluetooth.get_default();

  return (
    <QSButton
      connection={[bluetooth, "isPowered"]} // Changed to camelCase
      onClicked={() => bluetooth.toggle()}
      onSecondaryClick={() => {
        execAsync(["blueman-manager"]);
      }}
      iconName={createBinding(
        bluetooth,
        "isPowered",
      )((v: boolean) => (v ? "bluetooth" : "bluetooth_disabled"))}
      tooltip="Click to enable or disable Bluetooth. Right click to open Blueman"
    />
  );
}

function Mic() {
  const wp = Wp.get_default();
  const defaultMicrophone = wp?.defaultMicrophone;

  if (!defaultMicrophone) {
    return null; // Don't render if defaultMicrophone is not available
  }

  return (
    <QSButton
      connection={[defaultMicrophone, "mute"]}
      onClicked={() => {
        const mute = defaultMicrophone.mute;
        defaultMicrophone.set_mute(!mute);
      }}
      iconName={createBinding(
        defaultMicrophone,
        "mute",
      )((v: boolean) => (v ? "mic_off" : "mic"))}
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
        "dontDisturb", // Changed to camelCase
      )((dnd: boolean) => (dnd ? "notifications_off" : "notifications"))}
      tooltip="Click to change DND mode"
    />
  );
}

function IdleInhibitor() {
  const [idleInhibitor, setIdleInhibitor] = createState(false);

  const setupIdleInhibitor = async () => {
    try {
      const pid = await execAsync(["pidof", "idle-inhibitor.py"]);
      setIdleInhibitor(pid.trim() !== "");
    } catch (e) {
      setIdleInhibitor(false);
    }
  };

  return (
    <QSButton
      setup={setupIdleInhibitor} // Call setup function to check initial state
      connection={[idleInhibitor, null, (v: boolean) => v]}
      onClicked={() => {
        const newState = !idleInhibitor.get();
        setIdleInhibitor(newState); // Update state immediately
        if (newState) {
          execAsync([
            "bash",
            "-c",
            `pidof idle-inhibitor.py || ${SRC}/scripts/idleInhibitor.py `,
          ]).catch(print);
        } else {
          execAsync(["bash", "-c", "pkill -f idle-inhibitor.py"]).catch(print);
        }
      }}
      iconName={"coffee"}
      tooltip="Keeping your system awake"
    />
  );
}

function PowerProfiles() {
  const powerprofiles = AstalPowerProfiles.get_default();

  const icons = [
    {
      profile: "power-saver",
      icon: "energy_savings_leaf",
    },
    {
      profile: "balanced",
      icon: "balance",
    },
    {
      profile: "performance",
      icon: "rocket_launch",
    },
  ];

  return (
    <QSButton
      connection={[
        powerprofiles,
        "activeProfile",
        (profile) => profile == "performance",
      ]}
      iconName={createBinding(
        powerprofiles,
        "activeProfile",
      )((profile) => icons.find((i) => i.profile === profile)?.icon)}
      onClicked={() => {
        const profile = powerprofiles.activeProfile;

        let nextProfile;
        if (profile === "performance") {
          nextProfile = "power-saver";
        } else if (profile === "balanced") {
          nextProfile = "performance";
        } else {
          nextProfile = "balanced";
        }

        powerprofiles.set_active_profile(nextProfile);
      }}
      tooltip="Change power profiles"
    />
  );
}

export default function Toggles() {
  return (
    <centerbox class="toggles" halign={Gtk.Align.CENTER}>
      <box $type="center" spacing={8}>
        <WifiButton />
        <BluetoothButton />
        <DND />
        <Mic />
        <IdleInhibitor />
        <PowerProfiles />
      </box>
    </centerbox>
  );
}
