
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services

PanelWindow {
    width: 300
    height: 60
    visible: true  // ✅ Make sure it's visible
    color: "transparent"  // Background of the window
    

   
  	// Give the window an empty click mask so all clicks pass through it.
		mask: Region {} 
		WlrLayershell.layer: WlrLayer.Overlay // Mouse Click thourgh
    Rectangle {
        anchors.fill: parent
        color: "#888888"
        radius: 10

        Text {
            anchors.centerIn: parent
            text: Config.text
            font.pixelSize: 20
            color: "white"
        }
    }
}

