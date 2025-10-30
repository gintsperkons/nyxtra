import qs.modules.launcher
import qs.modules.bar
import qs.services




import QtQuick
import QtQuick.Window
import Quickshell



ShellRoot {
    LazyLoader { active: Config.launcher.enabled; component: Launcher{} }
    LazyLoader { active: Config.bar.enabled; component: Bar{} }
}
