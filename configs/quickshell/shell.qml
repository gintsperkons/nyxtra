import qs.modules.launcher
import qs.modules.bar
import qs.modules.settings
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
  LazyLoader { active: Config.settings.enabled; component: Settings{} }



  GlobalShortcut {
    name: "barVisibleToggle"
    description: "Toggle bar shown"
    onPressed: {
      GlobalStates.barShow = !GlobalStates.barShow;
    }
  }

  GlobalShortcut {
    name: "launcherToggle"
    description: "Toggle launcher"
    onPressed: {
      if (GlobalStates.route.contains(Enums.route.launcher))
      {
        // GlobalStates.route.reset()
      } else {
        GlobalStates.route.push(Enums.route.launcher);
      }
    }
  }
}
