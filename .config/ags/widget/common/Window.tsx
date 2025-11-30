import { Astal, Gtk, Gdk } from "ags/gtk4";
import Graphene from "gi://Graphene";
import app from "ags/gtk4/app";

interface WindowProps extends Partial<Astal.Window.ConstructorProps> {
  name: string;
  namespace?: string;
  gdkmonitor?: Gdk.Monitor;
  anchor?: Astal.WindowAnchor;
  exclusivity?: Astal.Exclusivity;
  keymode?: Astal.Keymode;
  visible?: boolean;
  class?: string;

  onKey?: (
    ctrl: Gtk.EventControllerKey,
    keyval: number,
    keycode: number,
    mod: number,
  ) => void;
  onClickOutside?: () => void;
  onVisibilityChange?: (visible: boolean) => void;

  children?: any;
  valign?: Gtk.Align;
  halign?: Gtk.Align;
  vexpand?: boolean;
  hexpand?: boolean;
}

export default function Window({
  name,
  namespace,
  gdkmonitor,
  exclusivity,
  keymode = Astal.Keymode.ON_DEMAND,
  visible = false,
  class: className,
  onKey,
  onClickOutside,
  onVisibilityChange,
  children,
  valign = Gtk.Align.CENTER,
  halign = Gtk.Align.CENTER,
  vexpand = false,
  hexpand = false,
  ...rest
}: WindowProps) {
  let win: Astal.Window;
  let contentBox: Gtk.Box;

  const handleKey = (
    ctrl: Gtk.EventControllerKey,
    keyval: number,
    keycode: number,
    mod: number,
  ) => {
    if (keyval === Gdk.KEY_Escape) {
      win.visible = false;
    }
    onKey?.(ctrl, keyval, keycode, mod);
  };

  const handleClick = (
    _: Gtk.GestureClick,
    __: number,
    x: number,
    y: number,
  ) => {
    const [, rect] = contentBox.compute_bounds(win);
    const pos = new Graphene.Point({ x, y });

    if (!rect.contains_point(pos)) {
      win.visible = false;
      onClickOutside?.();
    }
  };

  return (
    <window
      application={app}
      $={(ref) => (win = ref)}
      name={name}
      namespace={namespace}
      gdkmonitor={gdkmonitor}
      exclusivity={exclusivity}
      keymode={keymode}
      visible={visible}
      layer={Astal.Layer.OVERLAY}
      margin={16}
      class={className}
      onNotifyVisible={({ visible }) => {
        if (visible) {
          contentBox.grab_focus();
        }
        onVisibilityChange?.(visible);
      }}
      {...rest}
    >
      <Gtk.EventControllerKey onKeyPressed={handleKey} />
      <Gtk.GestureClick onPressed={handleClick} />
      <box
        $={(ref) => (contentBox = ref)}
        name={`${name}-content`}
        valign={valign}
        halign={halign}
        vexpand={vexpand}
        hexpand={hexpand}
        orientation={Gtk.Orientation.VERTICAL}
      >
        {children}
      </box>
    </window>
  );
}
