pragma Singleton
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root
    readonly property list<MprisPlayer> list: Mpris.players.values
    readonly property MprisPlayer active: list[0] ?? null
}
