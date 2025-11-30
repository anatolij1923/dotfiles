import { For, Accessor, onCleanup } from "ags";
import { Gtk } from "ags/gtk4";

interface AnimatedListProps<T> {
  items: Accessor<T[]>; // обязательно Accessor
  renderItem: (item: T, index: Accessor<number>) => any;
  transitionDuration?: number;
}

export function AnimatedList<T>({
  items,
  renderItem,
  transitionDuration = 130,
}: AnimatedListProps<T>) {
  let hideTimer: any = null;

  function cancelClear() {
    if (hideTimer !== null) {
      clearTimeout(hideTimer);
      hideTimer = null;
    }
  }

  function clearAfterDelay() {
    cancelClear();
    hideTimer = setTimeout(() => {
      items([] as any); // очистка после анимации
      hideTimer = null;
    }, transitionDuration);
  }

  onCleanup(cancelClear);

  return (
    <revealer
      revealChild={items((arr) => arr.length > 0)} // напрямую от массива
      transitionType={Gtk.RevealerTransitionType.SWING_DOWN}
      transitionDuration={transitionDuration}
    >
      <box orientation={Gtk.Orientation.VERTICAL}>
        <For each={items}>{renderItem}</For>
      </box>
    </revealer>
  );
}
