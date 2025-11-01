
import qs
import qs.services
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
    

Scope {
    id: root
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
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            mask: Region {
                item:bg
            }

            Rectangle {
                id: bg
                anchors.fill: parent
                color: "#888888"
                focus: true
                radius: 10
                Label {
                    id: search

                    color: "#444"            // text color
                    background: Rectangle {   // background of the input
                        color: "#888"         // background color
                        radius: 6             // rounded corners
                        border.color: "#777" // border color
                        border.width: 2       // border thickness
                    }
                    focus:false
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 0
                    padding: 4
                    font.pixelSize: 20

                    
                }
                Rectangle {
                  id:selector
                  
                  anchors.left: parent.left
                  anchors.right: parent.right
                  implicitHeight:32
                  color: "#b3b3b3"  
                  y: search.height+selected*36   
                
                }
                ListView {
                  id: elementList
                  anchors.top: search.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.bottom: parent.bottom
                  clip: true
                  spacing: 4

                  model:appList

                  delegate: Row {
                      spacing: 8
                      height: 32

                      Text {
                          text: modelData.name
                          font.pixelSize: 14
                      }
                  }
                }
    
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        GlobalStates.launcherOpen = false
                        search.text = ""      // clear input
                    } else if (event.key === Qt.Key_Down){
                      if (root.selected < appList.length - 1)
                          root.selected += 1
                    } else if (event.key === Qt.Key_Up){
                      if (root.selected > 0)
                          root.selected -= 1
                      console.log(selected)
                      console.log(selected)
                    } else if (event.key === Qt.Key_Return){
                        if (appList.length > root.selected){
                          appList[root.selected].execute()
                          GlobalStates.launcherOpen = false
                        }
                    } else if (event.key === Qt.Key_Backspace) {
                        search.text = search.text.slice(0, -1)
                        appList = Applications.search(search.text).slice();
                    } else {
                        search.text += event.text   // append typed character
                        appList = Applications.search(search.text).slice();
                        console.log(appList.length)

                    }
                }

             
            }

        
        
            HyprlandFocusGrab { // Click outside to close
                id: grab
                windows: [ launcher ]
                active: loader.active
                onCleared: () => {
                    if (!active) GlobalStates.launcherOpen = false;
                }

                
            }
        }
    
        MouseArea {
            anchors.fill: parent // cover full screen
            propagateComposedEvents: true
            onClicked: {
                if (launcher.containsMouse) {
                    GlobalStates.launcherOpen = false
                }
            }
        }

 
    }
                   
    function toggleLauncher() {
        GlobalStates.launcherOpen = !GlobalStates.launcherOpen
        
    }
    
  

    
    GlobalShortcut {
        name: "launcherToggle"
        description: "Toggle launcher"
        onPressed: {
            root.toggleLauncher();
            root.selected = 0
            appList = Applications.search("")
        }
    }
}