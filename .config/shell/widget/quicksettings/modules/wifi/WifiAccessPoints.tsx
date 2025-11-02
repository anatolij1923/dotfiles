import { createBinding, For, With } from "ags";
import { Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";
import AstalNetwork from "gi://AstalNetwork";
export default function WifiAccessPoints() {
  const wifi = AstalNetwork.get_default().wifi;

  const sorted = (arr: Array<AstalNetwork.AccessPoint>) => {
    return arr
      .filter((ap) => !!ap.ssid)
      .sort((a, b) => b.strength - a.strength);
  };

  async function connect(ap: AstalNetwork.AccessPoint) {
    try {
      await execAsync(`nmcli d wifi connect ${ap.bssid}`);
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <box
      name={"wifi-aps"}
      orientation={Gtk.Orientation.VERTICAL}
      class="wifi-aps"
    >
      <Gtk.ScrolledWindow>
        <For each={createBinding(wifi, "accessPoints")}>
          {(ap: AstalNetwork.AccessPoint) => (
            <button hexpand>
              <label label={createBinding(ap, "ssid")} />
            </button>
          )}
        </For>
      </Gtk.ScrolledWindow>
    </box>
  );
}
