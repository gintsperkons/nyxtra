import qs.services.models

pragma Singleton
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

QtObject {
    id: powerMenuItems   
    property Process proc: Process { }


    function run(cmd) {
        proc.exec(["sh", "-c", cmd])
    }


    property var items: [
        { name: "Shutdown", execute: () => run("systemctl poweroff"), categories:["Power"] },
        { name: "Reboot", execute: () => run("systemctl reboot"), categories:["Power"]  }
    ]

    function search(query = "") {


        const queryFull = query.trim();

        let typeSearch = "";
        let q = queryFull;

        // Match symbol + optional word + rest
        const match = queryFull.match(/^([@#!$])(\S+)?\s*(.*)/);

        if (match) {
            typeSearch = match[2] || ""; // word after symbol or empty
            q = match[3] || "";          // remaining query
        }

        // Only restrict if typeSearch has characters
        if (typeSearch.length > 0) {
            const allowed = "power";
            if (!allowed.startsWith(typeSearch.toLowerCase())) {
                return []; // skip because the partial word does not match allowed
            }
        }

        // If typeSearch is empty, it will pass and search for all
        q = q.toLowerCase();

        console.log("typeSearch:", typeSearch); // "" if searching for all
        console.log("search text:", q);



        const results = []

        for (let i = 0; i < items.length; i++) {  // ✅ correct reference
            const item = items[i]
            const categories = (item.categories || []).map(c => (c || "").toLowerCase());

            
            if (!item) continue

            if ((item.name.toLowerCase().includes(q) || categories.some(c => c.includes(q)) )) {
                results.push({
                    name: item.name,
                    execute: item.execute,
                    icon: null,
                    categories:item.categories,
                    type: "power"
                })
            }
        }

        return results
    }
}

