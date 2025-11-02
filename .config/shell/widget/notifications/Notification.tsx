import Gtk from "gi://Gtk?version=4.0";
import Gdk from "gi://Gdk?version=4.0";
import Adw from "gi://Adw";
import GLib from "gi://GLib";
import AstalNotifd from "gi://AstalNotifd";
import Pango from "gi://Pango";
import { createBinding, createState } from "ags";

function isIcon(icon?: string | null) {
  const iconTheme = Gtk.IconTheme.get_for_display(Gdk.Display.get_default()!);
  return icon && iconTheme.has_icon(icon);
}

function fileExists(path: string) {
  return GLib.file_test(path, GLib.FileTest.EXISTS);
}

function time(time: number, format = "%H:%M") {
  return GLib.DateTime.new_from_unix_local(time).format(format)!;
}

function urgency(n: AstalNotifd.Notification) {
  const { LOW, NORMAL, CRITICAL } = AstalNotifd.Urgency;
  switch (n.urgency) {
    case LOW:
      return "low";
    case CRITICAL:
      return "critical";
    case NORMAL:
    default:
      return "normal";
  }
}

function truncateBody(text: string, max = 40) {
  return text.length > max ? text.slice(0, max) + "…" : text;
}

export default function Notification({
  notification: n,
  showActions = true,
}: {
  notification: AstalNotifd.Notification;
  showActions: boolean;
}) {
  const [isExpanded, setExpanded] = createState(false);
  return (
    <Adw.Clamp maximumSize={400}>
      <box
        widthRequest={400}
        class={`Notification ${urgency(n)}`}
        orientation={Gtk.Orientation.VERTICAL}
      >
        <box class="header">
          {(n.appIcon || isIcon(n.desktopEntry)) && (
            <box class="app-icon-box">
              <image
                class="app-icon"
                visible={Boolean(n.appIcon || n.desktopEntry)}
                iconName={n.appIcon || n.desktopEntry}
                pixelSize={24}
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
              />
            </box>
          )}
          <label
            class="app-name"
            halign={Gtk.Align.START}
            ellipsize={Pango.EllipsizeMode.END}
            label={n.appName || "Unknown"}
          />
          <label
            class="time"
            hexpand
            halign={Gtk.Align.END}
            label={time(n.time)}
          />
          <button
            onClicked={() => setExpanded(!isExpanded.get())}
            class="expand-button"
          >
            <label
              label={isExpanded(() =>
                isExpanded.get() ? "keyboard_arrow_up" : "keyboard_arrow_down",
              )}
              class="material-icon"
            />
          </button>
          {/* <button onClicked={() => n.dismiss()} class="close-button"> */}
          {/*   <image iconName="window-close-symbolic" /> */}
          {/* </button> */}
        </box>
        <box class="content">
          {n.image && fileExists(n.image) && (
            <image
              valign={Gtk.Align.START}
              class="image"
              pixel_size={80}
              file={n.image}
              overflow={Gtk.Overflow.HIDDEN}
            />
          )}
          {n.image && isIcon(n.image) && (
            <box valign={Gtk.Align.START} class="icon-image">
              <image
                iconName={n.image}
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
              />
            </box>
          )}
          <box orientation={Gtk.Orientation.VERTICAL}>
            <label
              class="summary"
              halign={Gtk.Align.START}
              xalign={0}
              label={n.summary}
              ellipsize={Pango.EllipsizeMode.END}
            // maxWidthChars={19}
            />
            {n.body && (
              <>
                <label
                  visible={isExpanded(() => !isExpanded.get())}
                  class="body"
                  wrap
                  useMarkup
                  halign={Gtk.Align.START}
                  xalign={0}
                  justify={Gtk.Justification.FILL}
                  ellipsize={Pango.EllipsizeMode.END}
                  label={truncateBody(n.body, 40)}
                />
                <revealer
                  revealChild={isExpanded}
                  transitionDuration={300}
                  transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                >
                  <label
                    class="body"
                    wrap
                    useMarkup
                    halign={Gtk.Align.START}
                    xalign={0}
                    justify={Gtk.Justification.FILL}
                    label={n.body}
                  />
                </revealer>
              </>
            )}
          </box>
        </box>
        {showActions && (
          <revealer
            revealChild={isExpanded}
            transitionDuration={200}
            transitionType={Gtk.RevealerTransitionType.SWING_DOWN}
          >
            <box class="actions">
              <button hexpand onClicked={() => n.dismiss()} class="close-button">
                <label label="close" class="close-button" />
              </button>
              {n.actions.map(({ label, id }) => (
                <button hexpand onClicked={() => n.invoke(id)}>
                  <label
                    label={label}
                    halign={Gtk.Align.CENTER}
                    ellipsize={Pango.EllipsizeMode.END}
                  />
                </button>
              ))}
            </box>
          </revealer>
        )}
      </box>
    </Adw.Clamp>
  );
}
