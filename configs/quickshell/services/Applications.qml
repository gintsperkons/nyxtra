pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

QtObject {
    id: config


    // Helper function to find the first existing image
    function firstExistingIcon(iconName) {
        if (!iconName) return "icons/default.png";

        let paths = [
            "/usr/share/pixmaps/" + iconName + ".svg",
            "/usr/share/icons/hicolor/scalable/apps/" + iconName + ".svg",
            "/usr/share/icons/hicolor/symbolic/apps/" + iconName + ".svg",
            "/usr/share/pixmaps/" + iconName + ".png",
            "/usr/share/icons/hicolor/256x256/apps/" + iconName + ".png",
            "/usr/share/icons/hicolor/128x128/apps/" + iconName + ".png",
            "/usr/share/icons/hicolor/64x64/apps/" + iconName + ".png",
            "/usr/share/icons/hicolor/32x32/apps/" + iconName + ".png",
            "/usr/share/icons/hicolor/16x16/apps/" + iconName + ".png",
            "/usr/share/icons/AdwaitaLegacy/32x32/legacy/" + iconName + ".png"
        ];

        // Temporary hidden image
        let tmpImage = Qt.createQmlObject('import QtQuick 2.0; Image { visible: false }', Qt.application);


        for (let p of paths) {
            tmpImage.source = p;
            if (tmpImage.status === Image.Ready) {
                tmpImage.destroy();
                return p; // first valid path
            }
        }

        tmpImage.destroy();
        return "icons/default.png"; // fallback
    }



    function search(query) {
        const results = [];


        for (let i = 0; i < DesktopEntries.applications.values.length; i++) {
            const app = DesktopEntries.applications.values[i];
            if (!app) continue;
            
            const name = (app.name || "").toLowerCase();
            const generic = (app.genericName || "").toLowerCase();
        
            if (name.includes(query) || generic.includes(query)) {
                results.push({
                  name:app.name,
                  execute:app.execute,
                  icon:firstExistingIcon(app.icon)
                });
            }
        }

        return results;
    }
}
