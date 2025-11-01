pragma Singleton
import Quickshell
import Quickshell.Wayland
import QtQuick

QtObject {
    id: keylistener
    name: "keylistener"

    // Wayland global keyboard grab
    WlrKeyboard {
        id: kb
        onKeyPressed: (key, mods) => {
            // Example toggle: Meta+Space
            if (key === Qt.Key_Space && mods.meta) {
                console.log("Space pressed")
            }
        }
    }
}
