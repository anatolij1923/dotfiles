import { Gtk } from "ags/gtk4";
import { Header } from "./Header";
import { SwitchRow } from "../controls/SwitchRow";
import AstalNetwork from "gi://AstalNetwork";
import { createBinding, createComputed, For } from "ags";
import { createPoll } from "ags/time";
import SettingsPage from "./SettingsPage";

export default function NetworkPage() {
  const wifi = AstalNetwork.get_default().wifi;
  const wifiEnabled = createBinding(wifi, "enabled");

  const accessPoints = createPoll<AstalNetwork.AccessPoint[]>(
    [],
    20000,
    async () => {
      await wifi.scan();
      const aps = wifi.get_access_points();

      return aps
        .filter((ap) => !!ap.ssid)
        .sort((a, b) => b.strength - a.strength);
    },
  );

  return (
    <SettingsPage className="page network-page" headerTitle="Network">
      <SwitchRow
        label="Wi-Fi"
        value={wifiEnabled}
        onChange={(v) => wifi.set_enabled(v)}
      />

      <Gtk.ScrolledWindow hexpand vexpand>
        <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
          <For each={accessPoints}>
            {(ap: AstalNetwork.AccessPoint) => (
              <box class="wifi-ssid-box">
                <label label={ap.ssid} />
              </box>
            )}
          </For>
        </box>
      </Gtk.ScrolledWindow>
    </SettingsPage>
  );
}
