import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules.settings
import qs.modules.settings.pages

StackLayout {
    id: root

    required property int currentPage
    currentIndex: root.currentPage

    AppearancePage {}
    BarPage {}
    BackgroundPage {}
    LauncherPage {}
    SystemPage {}
    AboutPage {}
}
