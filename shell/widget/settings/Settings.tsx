import { Gtk } from "ags/gtk4";
import Adw from "gi://Adw?version=1";
import SettingsButton from "./SettingsButton";
import Appearance from "./pages/Appearance";
import { createState, For } from "ags";
import About from "./pages/About";
import Hyprland from "./pages/Hyprland";
import NetworkPage from "./pages/NetworkPage";
import BluetoothPage from "./pages/BluetoothPage";

const [settingsPage, setSettingsPage] = createState("network");

const settingsButtons = [
  {
    icon: "wifi",
    label: "Network",
    page: "network",
  },
  {
    icon: "bluetooth",
    label: "Bluetooth",
    page: "bluetooth",
  },
  {
    icon: "palette",
    label: "Appearance",
    page: "appearance",
  },
  {
    icon: "settings",
    label: "Hyprland",
    page: "hyprland",
  },
  {
    icon: "info",
    label: "About",
    page: "about",
  },
];

function ButtonsColumn() {
  return (
    <box
      class="buttons-column"
      orientation={Gtk.Orientation.VERTICAL}
      halign={Gtk.Align.START}
      hexpand={false}
      spacing={16}
    >
      <box class="header">
        <label label="Settings" xalign={0} hexpand />
        {/* TODO: make buttons menu foldable */}
        <button class="fold">
          <label label="menu" class="material-icon" />
        </button>
      </box>
      <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
        {settingsButtons.map((btn) => (
          <SettingsButton
            icon={btn.icon}
            label={btn.label}
            onClicked={() => setSettingsPage(btn.page)}
            connection={settingsPage}
            pageName={btn.page}
          />
        ))}
      </box>
    </box>
  );
}

function Page() {
  return (
    <box>
      <Gtk.Stack
        visibleChildName={settingsPage}
        transitionType={Gtk.StackTransitionType.CROSSFADE}
      >
        <box $type="named" name="network">
          <NetworkPage />
        </box>
        <box $type="named" name="bluetooth">
          <BluetoothPage />
        </box>
        <box $type="named" name="appearance">
          <Appearance />
        </box>
        <box $type="named" name="hyprland">
          <Hyprland />
        </box>
        <box $type="named" name="about">
          <About />
        </box>
      </Gtk.Stack>
    </box>
  );
}

export default function Settings() {
  return (
    <Gtk.Window name="settings" title="Settings" hideOnClose={true}>
      <box class="settings">
        <ButtonsColumn />
        <Page />
      </box>
    </Gtk.Window>
  );
}
