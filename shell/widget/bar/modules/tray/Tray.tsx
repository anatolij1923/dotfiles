import { createBinding, For } from "ags";
import { Gtk } from "ags/gtk4";
import AstalTray from "gi://AstalTray?version=0.1";

export default function Tray() {
  const tray = AstalTray.get_default();
  const items = createBinding(tray, "items");

  const init = (btn: Gtk.Button, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel;
    btn.insert_action_group("dbusmenu", item.actionGroup);
    item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup);
    });
  };

  return (
    <box class="tray">
      <For each={items}>
        {(item) =>
          item.gicon ? (
            <menubutton $={(self) => init(self, item)}>
              <image gicon={createBinding(item, "gicon")} />
            </menubutton>
          ) : null
        }
      </For>
    </box>
  );
}
