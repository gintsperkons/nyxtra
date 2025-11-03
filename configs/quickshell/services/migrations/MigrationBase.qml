import QtQuick.LocalStorage
import QtQuick

pragma Singleton
QtObject {
    function addColumnIfNotExists(tx, tableName, columnName, columnType) {
        // Get existing columns
        var rs = tx.executeSql("PRAGMA table_info(" + tableName + ");")
        var exists = false
        for (var i = 0; i < rs.rows.length; i++) {
            if (rs.rows.item(i).name === columnName) {
                exists = true
                break
            }
        }

        // Add column if it does not exist
        if (!exists) {
            tx.executeSql("ALTER TABLE " + tableName + " ADD COLUMN " + columnName + " " + columnType + ";")
        }
    }


}