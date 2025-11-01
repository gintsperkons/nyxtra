
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

    Loader {
        id: loader   
        active: GlobalStates.launcherOpen 
       
        sourceComponent:PanelWindow {
            id: launcher
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Overlay
            implicitWidth: 300

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
    
                Keys.onPressed: {
                    if (event.key === Qt.Key_Escape) {
                        GlobalStates.launcherOpen = false
                        search.text = ""      // clear input
                    } else if (event.key === Qt.Key_Backspace) {
                        search.text = search.text.slice(0, -1)
                    } else {
                        search.text += event.text   // append typed character
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
        }
    }
}