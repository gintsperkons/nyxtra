import qs.services.models

pragma Singleton
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

QtObject {
    id: config
    // Get home directory
    property string homeDir: StandardPaths.writableLocation(StandardPaths.HomeLocation)


    // Helper function to find the first existing image
    function firstExistingIcon(iconName) {


        let paths = [
            homeDir+"/.local/share/icons/"+iconName+".png",
            homeDir+"/.local/share/icons/hicolor/256x256/apps/"+iconName+".png",
            "/usr/share/icons/hicolor/256x256/apps/" + iconName + ".png",
            homeDir+"/.local/share/icons/hicolor/128x128/apps/"+iconName+".png",
            "/usr/share/icons/hicolor/128x128/apps/" + iconName + ".png",
            homeDir+"/.local/share/icons/hicolor/64x64/apps/"+iconName+".png",
            "/usr/share/icons/hicolor/64x64/apps/" + iconName + ".png",
            "/usr/share/pixmaps/" + iconName + ".svg",
            "/usr/share/pixmaps/" + iconName + ".png",
            homeDir+"/.local/share/icons/hicolor/32x32/apps/"+iconName+".png",
            "/usr/share/icons/hicolor/32x32/apps/" + iconName + ".png",
            homeDir+"/.local/share/icons/hicolor/16x16/apps/"+iconName+".png",
            "/usr/share/icons/hicolor/16x16/apps/" + iconName + ".png",
            "/usr/share/icons/hicolor/scalable/apps/" + iconName + ".svg",
            "/usr/share/icons/hicolor/symbolic/apps/" + iconName + ".svg",
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




    function search(query = "") {
        const results = []

        // Build a map of usage counts
        const appUsages = ApplicationModel.getAllUsages() // returns [{name, usageCount}, ...]
        const usageMap = {}
        for (let i = 0; i < appUsages.length; i++) {
            usageMap[appUsages[i].name] = appUsages[i].usageCount
        }
        const seen = new Set()
        // Search apps
        for (let i = 0; i < DesktopEntries.applications.values.length; i++) {
            const app = DesktopEntries.applications.values[i]
            if (!app) continue

            


            const name = (app.name || "").toLowerCase();
            const generic = (app.genericName || "").toLowerCase();
            const categories = (app.categories || []).map(c => (c || "").toLowerCase());
            const q = query.toLowerCase()

            if (seen.has(name) || app.noDisplay) continue
            seen.add(name)


            if ((name.includes(q) || generic.includes(q) || categories.some(c => c.includes(q)) )) {
                console.log(JSON.stringify(app));
                results.push({
                    name: app.name,
                    execute: app.execute,
                    icon: firstExistingIcon(app.icon),
                    categories: app.categories,
                    type: "application",
                    usageCount: usageMap[app.name] || 0 // default to 0 if not in cache
                })
            }
        }

        // Sort by usageCount descending
        results.sort(function(a, b) {
            return b.usageCount - a.usageCount
        })

        return results
    }


}
