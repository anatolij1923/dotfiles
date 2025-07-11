import { createBinding, For, onCleanup } from "ags";
import { Gtk } from "ags/gtk4";
import AstalTray from "gi://AstalTray?version=0.1";

export default function Tray() {
  const tray = AstalTray.get_default();
  const items = createBinding(tray, "items");

  const init = (btn: Gtk.Button, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel;
    btn.insert_action_group("dbusmenu", item.actionGroup);

    const id = item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup);
    });

    onCleanup(() => {
      item.disconnect(id);
    });
  };

  return (
    <box class="tray">
      <For each={items}>
        {(item) =>
          item.gicon ? (
            <menubutton $={(self) => init(self, item)}>
              <image gicon={createBinding(item, "gicon")} pixelSize={16} />
            </menubutton>
          ) : null
        }
      </For>
    </box>
  );
}
