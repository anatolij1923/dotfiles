import { For, createComputed, createState } from "ags";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import AstalApps from "gi://AstalApps";
import Window from "../common/Window";
import App from "ags/gtk4/app";

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

export default function Applauncher() {
  let searchentry: Gtk.Entry;

  const apps = new AstalApps.Apps();
  const [list, setList] = createState(new Array<AstalApps.Application>());
  const [calcResult, setCalcResult] = createState("");

  function isMathExpression(text: string) {
    return /^[0-9+\-*/().\s]|sqrt/.test(text);
  }

  function search(text: string) {
    // if (text === "") setList([]);
    // else
    if (text === "") {
      setList([]);
      setCalcResult("");
      return;
    }

    let processedText = text.replace(/sqrt\(/g, "Math.sqrt(");

    if (isMathExpression(text)) {
      try {
        const result = eval(processedText);
        if (typeof result === "number" && isFinite(result)) {
          setCalcResult(result.toString());
          setList([]);
          return;
        }
      } catch (e) {}
    }
    setCalcResult("");
    setList(apps.fuzzy_query(text).slice(0, 8));
  }

  function launch(app?: AstalApps.Application) {
    if (app) {
      // The common Window component will handle hiding the window
      app.launch();
      hide();
    }

    if (calcResult.get() !== "") {
      return;
    }
  }

  function hide() {
    App.get_window("launcher")?.hide();
  }

  // handle alt + number key
  function onKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number
  ) {
    if (mod === Gdk.ModifierType.ALT_MASK) {
      for (const i of [1, 2, 3, 4, 5, 6, 7, 8, 9] as const) {
        if (keyval === Gdk[`KEY_${i}`]) {
          return launch(list.get()[i - 1]), hide();
        }
      }
    }
    if (keyval === Gdk.KEY_Return && calcResult.get() !== "") {
      // Copy result to clipboard
      Gtk.Clipboard.get_default()?.set_text(calcResult.get());
      hide();
      return;
    }
  }

  return (
    <Window
      name="launcher"
      anchor={TOP | BOTTOM | LEFT | RIGHT}
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.EXCLUSIVE}
      onKey={onKey}
      onVisibilityChange={(visible) => {
        if (visible) searchentry.grab_focus();
        else searchentry.set_text("");
      }}
    >
      <box class="search">
        <entry
          $={(ref) => (searchentry = ref)}
          hexpand
          onNotifyText={({ text }) => search(text)}
          primaryIconName={"system-search-symbolic"}
          placeholderText="Search or calculate"
        />
      </box>
      <Gtk.Separator visible={list((l) => l.length > 0)} class="separator" />

      <revealer
        revealChild={calcResult((r) => r !== "")}
        transitionDuration={130}
        transitionType={Gtk.RevealerTransitionType.SWING_DOWN}
      >
        <box class="calculator-result">
          <label label={calcResult} xalign={0} />
        </box>
      </revealer>
      <revealer
        revealChild={list((l) => l.length > 0)}
        transitionDuration={130}
        transitionType={Gtk.RevealerTransitionType.SWING_DOWN}
      >
        <box orientation={Gtk.Orientation.VERTICAL}>
          <For each={list}>
            {(app, index) => (
              <button onClicked={() => launch(app)}>
                <box spacing={12}>
                  <image iconName={app.iconName} pixelSize={32} />
                  <label label={app.name} maxWidthChars={40} wrap />
                  <label
                    hexpand
                    halign={Gtk.Align.END}
                    label={index((i) => `󰘳  ${i + 1}`)}
                  />
                </box>
              </button>
            )}
          </For>
        </box>
      </revealer>
    </Window>
  );
}
