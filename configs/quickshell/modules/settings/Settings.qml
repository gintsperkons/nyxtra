
import qs
import qs.services
import qs.services.models
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
    

Scope {
  id: settingsRoot


  Loader {
    id: loader   
    active: GlobalStates.route.contains(Enums.route.settings)
    sourceComponent:PanelWindow {
      id: settings
      color: "transparent"
      WlrLayershell.layer: WlrLayer.Overlay
      implicitWidth: 800
      implicitHeight:600
    }
  }
}