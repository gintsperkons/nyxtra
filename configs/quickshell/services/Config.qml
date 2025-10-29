

pragma Singleton
import QtQuick 
import Quickshell.Io

QtObject {
    id: config

    property string text: ""
    property int count: 0
    property bool enabled: false

    property var file: FileView {
        path: Qt.resolvedUrl("../config.json")
        watchChanges: true
        adapter: JsonAdapter {
            id: adapter
            property string text
            property int count
            property bool enabled
        }

        onLoaded: updateFromAdapter()

        // Fires whenever adapter properties are updated (external changes or QML changes)
        onFileChanged: updateFromAdapter()
    }

    function updateFromAdapter() {
        reload()
        // Only assign if value is different to trigger QML bindings
        if (Config.text !== file.adapter.text) Config.text = file.adapter.text
        if (Config.count !== file.adapter.count) Config.count = file.adapter.count
        if (Config.enabled !== file.adapter.enabled) Config.enabled = file.adapter.enabled

        console.log("[Config] Updated:", Config.text, Config.count, Config.enabled)
    }

    function reload() {
        file.reload()
    }

    function save() {
        file.adapter.text = Config.text
        file.adapter.count = Config.count
        file.adapter.enabled = Config.enabled
        file.writeAdapter()
    }
}

