import qs.services.migrations
import QtQuick.LocalStorage
import Quickshell
import QtQuick

pragma Singleton

QtObject {
    property int currentVersion: 1


    function getDB() {
        return LocalStorage.openDatabaseSync(
            "QuickShellCache",
            String(currentVersion),
            "Laravel-style generic cache for QuickShell",
            1024 * 1024 // 1 MB, adjust as needed
        )
    }

    

    function init() {
        var db = getDB();
        db.transaction(function (tx) {
            M1.up(tx);
        })
        migrate();
    }




}