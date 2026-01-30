import qs
import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root
    signal shouldReFocus
    signal unlocked

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    onCurrentTextChanged: {
        if (currentText.length > 0) {
            showFailure = false;
        }
    }

    function tryUnlock() {
        if (currentText.length === 0)
            return;
        root.unlockInProgress = true;
        pam.start();
    }

    PamContext {
        id: pam
        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.unlocked();
            } else {
                root.showFailure = true;
                
                failureResetTimer.restart();
            }
            root.currentText = "";
            root.unlockInProgress = false;
        }
    }

    Timer {
        id: failureResetTimer
        interval: 2000
        onTriggered: root.showFailure = false
    }
}
