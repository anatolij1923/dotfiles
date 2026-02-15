import QtQuick
import qs.common

Image {
    id: root
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    retainWhileLoading: true
    visible: opacity > 0
    opacity: (status === Image.Ready) ? 1 : 0

    Behavior on opacity {
        Anim {
            duration: Appearance.animDuration.xl
        }
    }
}
