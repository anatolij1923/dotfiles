import { Astal, Gtk, Gdk } from "ags/gtk4";
import Graphene from "gi://Graphene";
import type { WindowProps } from "astal/widget";
import app from "ags/gtk4/app";

interface CommonWindowProps extends WindowProps {
  name: string;
  anchor?: Astal.WindowAnchor;
  exclusivity?: Astal.Exclusivity;
  keymode?: Astal.Keymode;
  visible?: boolean;
  onKey?: (
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number
  ) => void;
  onClick?: (_e: Gtk.GestureClick, _: number, x: number, y: number) => void;
  onVisibilityChange?: (visible: boolean) => void;
  children?: any;
}

export default function Window({
  name,
  anchor,
  exclusivity,
  keymode,
  visible,
  onKey,
  onClick,
  onVisibilityChange,
  children,
  ...rest
}: CommonWindowProps) {
  let win: Astal.Window;
  let contentbox: Gtk.Box;

  function handleKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number
  ) {
    if (keyval === Gdk.KEY_Escape) {
      win.visible = false;
    }
    onKey?.(_e, keyval, _, mod);
  }

  function handleClick(_e: Gtk.GestureClick, _: number, x: number, y: number) {
    const [, rect] = contentbox.compute_bounds(win);
    const position = new Graphene.Point({ x, y });

    if (!rect.contains_point(position)) {
      win.visible = false;
      return true;
    }
    onClick?.(_e, _, x, y);
  }

  return (
    <window
      application={app}
      $={(ref) => (win = ref)}
      name={name}
      anchor={anchor}
      exclusivity={exclusivity}
      keymode={keymode}
      layer={Astal.Layer.OVERLAY}
      margin={10}
      onNotifyVisible={({ visible }) => {
        if (visible) {
          contentbox.grab_focus();
        }
        onVisibilityChange?.(visible);
      }}
      {...rest}
    >
      <Gtk.EventControllerKey onKeyPressed={handleKey} />
      <Gtk.GestureClick onPressed={handleClick} />
      <box
        $={(ref) => (contentbox = ref)}
        name={`${name}-content`}
        valign={Gtk.Align.CENTER}
        halign={Gtk.Align.CENTER}
        orientation={Gtk.Orientation.VERTICAL}
      >
        {children}
      </box>
    </window>
  );
}
