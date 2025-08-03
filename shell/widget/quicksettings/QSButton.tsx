import { createState, createBinding, createExternal } from "ags";
import { Gdk, Gtk } from "ags/gtk4";
import GObject from "gi://GObject?version=2.0";
import type { Accessor } from "ags";
import Pango from "gi://Pango?version=1.0";

// Define a union type for the connection prop
type ConnectionType =
  | [GObject.Object & Record<string, any>, string, ((v: any) => boolean)?]
  | [Accessor<any>, null, ((v: any) => boolean)?];

interface QSButtonProps {
  iconName: string | Accessor<string>; // Allow Accessor for iconName
  setup?: (self: Gtk.Widget) => void;
  onClicked?: () => void;
  connection?: ConnectionType; // Use the new union type
  tooltip?: string;
  onSecondaryClick?: () => void;
}

export default function QSButton({
  iconName,
  setup: originalSetup,
  onClicked,
  connection,
  tooltip,
  onSecondaryClick,
}: QSButtonProps) {
  const [cssClasses, setCssClasses] = createState<string[]>(["qs-button"]);

  const setup = (self: Gtk.Widget) => {
    if (connection) {
      const [source, propertyOrNull, cond] = connection;

      const gestures = new Gtk.GestureClick();
      gestures.set_button(0);
      gestures.connect("released", (_) => {
        const button = _.get_current_button();
        if (button === Gdk.BUTTON_SECONDARY) {
          onSecondaryClick?.();
        }
      });
      self.add_controller(gestures);

      const updateClasses = (v: any) => {
        const newClasses = ["qs-button"];
        if (cond ? cond(v) : v) newClasses.push("active");
        setCssClasses(newClasses);
        console.log("[DEBUG] updating classes to", newClasses);
      };

      // Check if the source is an Accessor
      if (
        propertyOrNull === null &&
        typeof (source as Accessor<any>).get === "function" &&
        typeof (source as Accessor<any>).subscribe === "function"
      ) {
        const accessor = source as Accessor<any>;
        const unsubscribe = accessor.subscribe(() => {
          updateClasses(accessor.get());
        });
        updateClasses(accessor.get()); // Set initial state

        self.connect("destroy", () => {
          unsubscribe();
        });
      } else {
        // Assume it's a GObject.Object connection
        const object = source as GObject.Object & Record<string, any>;
        const propertyName = String(propertyOrNull); // e.g., "isPowered", "dontDisturb"
        // Convert camelCase to kebab-case for GObject notify signals
        const signalName = propertyName
          .replace(/([A-Z])/g, "-$1")
          .toLowerCase();

        // console.log(
        //   "[DEBUG] binding setup for",
        //   propertyName,
        //   "initial value:",
        //   object[propertyName],
        // );

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
    }
    if (originalSetup) originalSetup(self);
  };

  return (
    <button
      // hexpand
      $={setup}
      cssClasses={cssClasses}
      onClicked={onClicked}
      tooltipText={tooltip}
    >
      <box>
        <label
          label={iconName} // This will now accept Accessor<string>
          halign={Gtk.Align.CENTER}
          class="material-icon"
        />
      </box>
    </button>
  );
}
