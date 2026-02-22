pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> list: Mpris.players.values
    
    readonly property MprisPlayer active: {
        const players = Mpris.players.values;
        if (players.length === 0) return null;
        
        for (let i = 0; i < players.length; i++) {
            if (players[i].playbackStatus === Mpris.Playing) {
                return players[i];
            }
        }
        
        return players[0];
    }

    function getSourceName(player) {
        if (!player) return "";
        return player.identity || "Unknown";
    }
}
