import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import qs.services

PanelWindow {

    property real batteryPct: 0


    id: panel
    implicitHeight: 24
    visible: true
    anchors.top: true
    anchors.left: true
    anchors.right: true

    // Key: make the window fully transparent
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay

    objectName: "topBar"
    Rectangle {
        anchors.fill: parent
        // Semi-transparent color (AA=88 -> ~50% opacity)
        color: "#000000ff"
        radius: 0

        Text {
            anchors.centerIn: parent
            text: DateTime.getTimeString(Config.bar.clockFormatShort)
            color: "white"
            font.pixelSize: 18
        }

        Text {
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

          text: {
                // Access the first device that is a battery directly from .values
                for (let i = 0; i < UPower.devices.values.length; i++) {
                    const dev = UPower.devices.values[i]
                    if (dev.isLaptopBattery) {
                        // QML tracks dev.percentage and dev.state automatically
                        return `${Math.round(dev.percentage*100)}% ${dev.state === 1 ? "⚡" : ""}`
                    }
                }
                return "—"
            }



          color: "white"
          font.pixelSize: 18
        }
    }
    
}
