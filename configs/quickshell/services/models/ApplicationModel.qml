import qs.services

import QtQuick


pragma Singleton


QtObject {
    id: applicationModel



    function incrementUsageCount(name) {
        var db = Cache.getDB()
        db.transaction(function(tx) {
            // Try to update first
            var rs = tx.executeSql(
                "UPDATE applications SET usageCount = usageCount + 1 WHERE name = ?",
                [name]
            )

            // If no row was updated, insert it
            if (rs.rowsAffected === 0) {
                tx.executeSql(
                    "INSERT INTO applications (name, usageCount) VALUES (?, ?)",
                    [name, 1]
                )
            }
        })
    }

    function getAllUsages() {
        var db = Cache.getDB()
        var results = []
        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT name, usageCount FROM applications")
            for (var i = 0; i < rs.rows.length; i++) {
                results.push({
                    name: rs.rows.item(i).name,
                    usageCount: rs.rows.item(i).usageCount
                })
            }
        })
        return results
    }

}