import { createBinding, createComputed, createExternal } from "ags";
import Hyprland from "gi://AstalHyprland";

export default function FocusedClient() {
  const hypr = Hyprland.get_default();
  const focusedClientAccessor = createBinding(hypr, "focusedClient");

  const title = createExternal("", (set) => {
    let currentClient: Hyprland.Client | null = null;
    let titleSignalId: number | null = null;

    const handleClientChange = () => {
      const newClient = focusedClientAccessor.get();

      if (currentClient && titleSignalId !== null) {
        currentClient.disconnect(titleSignalId);
        titleSignalId = null;
      }
      currentClient = newClient;

      if (currentClient) {
        const initialTitle = currentClient.initialTitle;
        set(initialTitle || "");

        titleSignalId = currentClient.connect(
          "notify::initial-title",
          (obj: Hyprland.Client) => {
            set(obj.initialTitle || "");
          },
        );
      } else {
        set("");
      }
    };
    const focusedClientUnsubscribe =
      focusedClientAccessor.subscribe(handleClientChange);
    handleClientChange();

    return () => {
      if (currentClient && titleSignalId !== null) {
        currentClient.disconnect(titleSignalId);
        titleSignalId = null;
      }
      focusedClientUnsubscribe()
    };
  });

  return (
    <box class="focused-client">
      <label label={title} />
    </box>
  );
}
