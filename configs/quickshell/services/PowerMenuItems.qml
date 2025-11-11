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
        { name: "Shutdown", execute: () => run("systemctl poweroff") },
        { name: "Reboot", execute: () => run("systemctl reboot") }
    ]

    function search(query = "") {
        const q = query.toLowerCase()
        const results = []

        for (let i = 0; i < items.length; i++) {  // ✅ correct reference
            const item = items[i]
            if (!item) continue

            if (item.name.toLowerCase().includes(q)) {
                results.push({
                    name: item.name,
                    execute: item.execute,
                    icon: null,
                    type: "power"
                })
            }
        }

        return results
    }
}

