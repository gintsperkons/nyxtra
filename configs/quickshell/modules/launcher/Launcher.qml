
import qs
import qs.services
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
    

Scope {
  id: launcherRoot
  property var appList: []
  property int selected: 0

  Loader {
    id: loader   
    active: GlobalStates.launcherOpen 
    
    sourceComponent:PanelWindow {
      id: launcher
      color: "transparent"
      WlrLayershell.layer: WlrLayer.Overlay
      implicitWidth: 800
      implicitHeight:600

      readonly property HyprlandMonitor monitor: Hyprland.monitorFor(launcher.screen)
      property bool monitorIsFocused: (Hyprland.focusedMonitor?.id == monitor?.id)

      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "quickshell:launcher"

      Rectangle {
        id: bg
        anchors.fill: parent
        color: Config.launcher.backgroundColor
        border.color: Config.launcher.borderColor 
        border.width: 1
        radius: 10
        focus: false
        TextField {
          id: search
          focus: true
          color: Config.launcher.textColor
          background: Rectangle {  
              color:  Config.launcher.backgroundColor 
              radius: 6          
              border.color: Config.launcher.borderColor 
          }
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.margins: 0
          padding: 4
          font.pixelSize: 20
          
          onTextChanged: {
            launcherRoot.appList = Applications.search(text).slice()
            launcherRoot.selected = 0
          }
            
          Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                launcherRoot.close()
            } else if (event.key === Qt.Key_Down){
              if (launcherRoot.selected < appList.length - 1)
              {
                launcherRoot.selected += 1
                elementList.positionViewAtIndex(launcherRoot.selected, ListView.Beginning)
              }
            } else if (event.key === Qt.Key_Up){
              if (launcherRoot.selected > 0)
              {
                launcherRoot.selected -= 1
                elementList.positionViewAtIndex(launcherRoot.selected, ListView.Beginning)
              }
            } else if (event.key === Qt.Key_Return){
              if (appList.length > launcherRoot.selected){
                appList[launcherRoot.selected].execute()
                launcherRoot.close()
              }
            }
          }
        }
        Rectangle {
          id:selector
          focus: false
          anchors.left: parent.left
          anchors.right: parent.right
          implicitHeight:32
          color: Config.launcher.cursorColor  
          y:  (selected * 36)+32-elementList.contentY
          border.color: Config.launcher.borderColor 
          border.width: 1
        }
        ListView {
          id: elementList
          focus: false
          anchors.top: search.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          clip: true
          spacing: 4
          model:appList

          delegate: Row {
            height: 32
            focus: false
            enabled: false
            Image {
              id: appIcon
              anchors.verticalCenter: parent.verticalCenter
              width: 32
              height: 32
              source: modelData.icon
          }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              focus: false
              text: modelData.name
              font.pixelSize: 14
              color: Config.launcher.textColor
            }
          }
        }
      }

  
  
      HyprlandFocusGrab { // Click outside to close
        id: grab
        windows: [ launcher ]
        active: loader.active
        onCleared: () => {
            if (!active) launcherRoot.close;
            search.text = ""
        }
      }
    }
  }
                  
  function toggleLauncher() {
    GlobalStates.launcherOpen = !GlobalStates.launcherOpen;
  }
  function close() {
    GlobalStates.launcherOpen = false;
  }
  
  GlobalShortcut {
    name: "launcherToggle"
    description: "Toggle launcher"
    onPressed: {
      launcherRoot.toggleLauncher();
      launcherRoot.selected = 0
      appList = Applications.search("")
    }
  }
}