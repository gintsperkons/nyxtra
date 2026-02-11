import qs.modules.launcher
import qs.modules.bar
import qs.modules.settings
import qs.services
import qs
import Quickshell.Io




import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland



ShellRoot {
    id : root
  Component.onCompleted: {
    Cache.init()
    Launcher.init()
  }


  LazyLoader { active: Config.launcher.enabled; component: Launcher{} }
  LazyLoader { active: Config.bar.enabled && GlobalStates.barShow; component: Bar{} }
  LazyLoader { active: Config.settings.enabled; component: Settings{} }



 


    IpcHandler {
        target: "root"
        function toggleLauncher(): void {
            if (GlobalStates.route.contains(Enums.route.launcher))
            {
                GlobalStates.route.reset()
            } else {
                GlobalStates.route.push(Enums.route.launcher);
            }
        }
        function toggleBarVisible(): void {
            GlobalStates.barShow = !GlobalStates.barShow;
        }
    }
}
