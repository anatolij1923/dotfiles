pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> list: Mpris.players.values
    
    property MprisPlayer manualPlayer: null

    readonly property MprisPlayer active: {
        if (manualPlayer && list.indexOf(manualPlayer) !== -1) {
            return manualPlayer;
        }
        
        if (list.length === 0) return null;
        
        for (let i = 0; i < list.length; i++) {
            if (list[i].playbackStatus === Mpris.Playing) {
                return list[i];
            }
        }
        
        return list[0];
    }

    function getSourceName(player) {
        if (!player) return "None";
        return player.identity || "Unknown";
    }
}
