import { For, createState, onCleanup } from "ags";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import AstalApps from "gi://AstalApps";
import Window from "../common/Window";
import App from "ags/gtk4/app";
import { evaluateExpression } from "../../utils/calculator";

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;
const TRANSITION_DURATION = 130; // ms — держи синхронно с revealer's transitionDuration

export default function Applauncher() {
  let searchentry: Gtk.Entry;

  const apps = new AstalApps.Apps();
  const [list, setList] = createState(new Array<AstalApps.Application>());
  const [calcResult, setCalcResult] = createState("");
  const [showList, setShowList] = createState(false);

  let hideTimer: any = null;
  function cancelClear() {
    if (hideTimer !== null) {
      clearTimeout(hideTimer);
      hideTimer = null;
    }
  }
  function clearListAfterDelay() {
    cancelClear();
    hideTimer = setTimeout(() => {
      setList([]);
      hideTimer = null;
    }, TRANSITION_DURATION);
  }

  onCleanup(() => {
    cancelClear();
  });

  function isMathExpression(text: string) {
    return /^[0-9+\-*/().\s]|sqrt/.test(text);
  }

  function search(text: string) {
    if (text === "") {
      // скрываем список (плавно), а очистку массива — после анимации
      setCalcResult("");
      setShowList(false);
      clearListAfterDelay();
      return;
    }

    if (isMathExpression(text)) {
      try {
        const result = evaluateExpression(text);
        if (typeof result === "number" && isFinite(result)) {
          setCalcResult(result.toString());
          // прячем список, затем очищаем его после анимации
          setShowList(false);
          clearListAfterDelay();
          return;
        }
      } catch (e) {
        // silently ignore
      }
    }

    // поиск приложений
    const results = apps.fuzzy_query(text).slice(0, 8);
    if (results.length > 0) {
      cancelClear();
      setList(results);
      setShowList(true);
    } else {
      // нет результатов — спрятать список, а старые элементы очистить после анимации
      setShowList(false);
      clearListAfterDelay();
    }
  }

  function launch(app?: AstalApps.Application) {
    if (app) {
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

  function onKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number,
  ) {
    if (mod === Gdk.ModifierType.ALT_MASK) {
      for (const i of [1, 2, 3, 4, 5, 6, 7, 8, 9] as const) {
        if (keyval === Gdk[`KEY_${i}`]) {
          return (launch(list.get()[i - 1]), hide());
        }
      }
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
        if (visible) {
          apps.reload();
          searchentry.grab_focus();
        } else {
          searchentry.set_text("");
          cancelClear();
          setList([]);
          setShowList(false);
        }
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
        transitionDuration={TRANSITION_DURATION}
        transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      >
        <box class="calculator-result">
          <label label={calcResult} xalign={0} />
        </box>
      </revealer>

      <revealer
        revealChild={showList((s) => s)}
        transitionDuration={TRANSITION_DURATION}
        transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
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
