pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: config
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
                  execute:app.execute
                });
            }
        }

        return results;
    }
}
