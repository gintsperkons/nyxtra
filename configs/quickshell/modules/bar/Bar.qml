import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services

PanelWindow {
    id: panel
    implicitWidth: 300
    implicitHeight: 24
    visible: true
    anchors.top: true

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
    }
}
