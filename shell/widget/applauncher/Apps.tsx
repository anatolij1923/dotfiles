import AstalApps from "gi://AstalApps?version=0.1";
import { Gtk } from "ags/gtk4";
import {  Accessor, For } from "ags";
import { appsList, setAppsList } from "./states";
import { hide, launchApplication } from "../../utils/util";

const apps = new AstalApps.Apps();

export function searchApps(text: string) {
  if (!text) {
    setAppsList([]);
    return;
  }
  setAppsList(apps.fuzzy_query(text).slice(0, 8));
}


function AppButton({
  app,
  index,
}: {
  app: AstalApps.Application;
  index: Accessor<number>;
}) {
  return (
    <button
      class="app-button"
      onClicked={() => {
        launchApplication(app);
        hide("launcher");
      }}
    >
      <box spacing={8}>
        <image iconName={app.icon_name} pixelSize={32} />
        <label label={app.name} xalign={0} />
        <label
          hexpand
          halign={Gtk.Align.END}
          label={index((i) => `󰘳  ${i + 1}`)}
        />
      </box>
    </button>
  );
}

export function Apps() {
  return (
    <revealer
      revealChild={appsList((l) => l.length > 0)}
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      transitionDuration={170}
    >
      <box orientation={Gtk.Orientation.VERTICAL} class="apps-list">
        <For each={appsList}>
          {(app, index) => <AppButton app={app} index={index} />}
        </For>
      </box>
    </revealer>
  );
}
