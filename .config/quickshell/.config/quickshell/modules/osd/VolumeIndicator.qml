import qs.services
import QtQuick

OSDIndicator {
    value: Audio.sink?.audio.volume ?? 0
    icon: Audio.sink?.audio.muted ? "volume_off" : "volume_up"
}
