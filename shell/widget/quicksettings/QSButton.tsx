import { createState, createBinding, createExternal } from "ags";
import { Gtk } from "ags/gtk4";
import GObject from "gi://GObject?version=2.0";
import type { Accessor } from "ags";
import Pango from "gi://Pango?version=1.0";

interface QSButtonProps<T extends GObject.Object> {
  iconName: string | Accessor<string>; // Allow Accessor for iconName
  label?: string | Accessor<string>;
  setup?: (self: Gtk.Widget) => void;
  onClicked?: () => void;
  connection?: [T & Record<string, any>, string, ((v: any) => boolean)?]; // Allow indexing with string
}

export default function QSButton<T extends GObject.Object>({
  iconName,
  label,
  setup: originalSetup,
  onClicked,
  connection,
}: QSButtonProps<T>) {
  const [cssClasses, setCssClasses] = createState<string[]>(["qs-button"]);

  const setup = (self: Gtk.Widget) => {
    if (connection) {
      const [object, property, cond] = connection;
      const propertyName = String(property); // e.g., "isPowered", "dontDisturb"
      // Convert camelCase to kebab-case for GObject notify signals
      const signalName = propertyName.replace(/([A-Z])/g, "-$1").toLowerCase();

      console.log(
        "[DEBUG] binding setup for",
        propertyName,
        "initial value:",
        object[propertyName]
      );

      const updateClasses = (v: any) => {
        const newClasses = ["qs-button"];
        if (cond ? cond(v) : v) newClasses.push("active");
        setCssClasses(newClasses);
        console.log("[DEBUG] updating classes to", newClasses);
      };

      if (propertyName != null) {
        const handlerId = object.connect(`notify::${signalName}`, () => {
          updateClasses(object[propertyName]);
        });
        // Construct getter name for camelCase properties (e.g., "isPowered" -> "getIsPowered")
        const getterName = `get${
          propertyName.charAt(0).toUpperCase() + propertyName.slice(1)
        }`;
        const value =
          getterName in object && typeof object[getterName] === "function"
            ? object[getterName]()
            : object[propertyName];
        updateClasses(value);

        self.connect("destroy", () => {
          object.disconnect(handlerId);
        });
      }
    }
    if (originalSetup) originalSetup(self);
  };

  return (
    <button
      // hexpand
      $={setup}
      cssClasses={cssClasses}
      onClicked={onClicked}
      tooltipText={label}
    >
      <box spacing={8} hexpand>
        <label
          label={iconName} // This will now accept Accessor<string>
          halign={Gtk.Align.CENTER}
          class="material-icon"
        />
        <box class="title">
          <label
            label={label}
            ellipsize={Pango.EllipsizeMode.END}
          />
        </box> 
      </box>
    </button>
  );
}
