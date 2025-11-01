
import qs
import qs.services
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
    
PanelWindow {
    id: launcher
    implicitWidth: 420
    implicitHeight: 500
    visible: GlobalStates.launcherOpen
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay

    // If you removed click-through, DO NOT include mask: Region {}


  	// Give the window an empty click mask so all clicks pass through it.
    Rectangle {
        anchors.fill: parent
        color: "#888888"
        radius: 10

        TextField {
            id: search
            placeholderText: "Search apps…"
            focus: true
            activeFocusOnPress: true
            anchors.centerIn: parent
            text: Config.text
            font.pixelSize: 20
            color: "white"
        }
    }
    
    function toggleLauncher() {
        GlobalStates.launcherOpen = !GlobalStates.launcherOpen
    }

    HyprlandFocusGrab { // Click outside to close
        id: grab
        windows: [ launcher ]
        active: launcher.active
        onCleared: () => {
            if (!active) GlobalStates.launcherOpen = false;
        }
    }

    GlobalShortcut {
        name: "launcherToggle"
        description: "Toggle launcher"
        onPressed: {
            launcher.toggleLauncher();
        }
    }

}

