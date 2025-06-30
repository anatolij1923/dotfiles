import { createComputed, createExternal, For } from "ags";
import AstalHyprland from "gi://AstalHyprland?version=0.1";

const MIN_WS = 5;

export default function Workspaces() {
  const hypr = AstalHyprland.get_default();

  const workspaces = createExternal(hypr.workspaces, (set) => {
    const update = () => set(hypr.workspaces);
    hypr.connect("notify::workspaces", update);
    update();
  });

  const sortedWorkspaces = workspaces((ws) =>
    ws.filter((w) => !(w.id >= -99 && w.id <= -2)).sort((a, b) => a.id - b.id),
  );

  const workspaceRange = createComputed([sortedWorkspaces], (sorted) => {
    const maxId = Math.max(MIN_WS, ...sorted.map((ws) => ws.id));
    return Array.from({ length: maxId }, (_, i) => i + 1);
  });

  return (
    <box class="workspaces" spacing={4}>
      <For each={workspaceRange}>
        {(id) => {
          const ws = hypr.get_workspace(id) ?? AstalHyprland.Workspace.dummy(id, null);

          const focusedWorkspace = createExternal(
            hypr.focusedWorkspace,
            (set) => {
              const update = () => set(hypr.focusedWorkspace);
              hypr.connect("notify::focused-workspace", update);
              update();
              return () => {};
            },
          );

          const classNames = createComputed([focusedWorkspace], (fw) => {
            const classes = [];
            if (fw?.id === ws.id) classes.push("focused");
            const clients = hypr.get_workspace(ws.id)?.get_clients() ?? [];
            if (clients.length === 0) classes.push("empty");
            return classes.join(" ");
          });

          return (
          <button 
              class={classNames}
              onClicked={() => ws.focus()}
          >
              <label label={id.toString()} />
            </button>
          )
        }}
      </For>
    </box>
  );
}
