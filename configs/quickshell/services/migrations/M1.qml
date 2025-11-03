import qs.services.migrations
import QtQuick.LocalStorage
import QtQuick


pragma Singleton

QtObject {
    id: _1

    property string tableName: "applications"

    function up(tx) { 
        tx.executeSql("CREATE TABLE " + tableName + " (id INTEGER PRIMARY KEY, name TEXT, usageCount INTEGER);");
    }
}
