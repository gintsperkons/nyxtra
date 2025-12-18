import qs.modules.launcher
import qs.modules.bar
import qs.services
import qs




import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland



ShellRoot {
    Component.onCompleted: {
        Cache.init()
        Launcher.init()
    }


    LazyLoader { active: Config.launcher.enabled; component: Launcher{} }
    LazyLoader { active: Config.bar.enabled && GlobalStates.barShow; component: Bar{} }



GlobalShortcut {
name: "barVisibleToggle"
description: "Toggle bar shown"
onPressed: {
    GlobalStates.barShow = !GlobalStates.barShow;
}
}
}
