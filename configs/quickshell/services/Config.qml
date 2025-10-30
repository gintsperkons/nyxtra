pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: config

    // Top-level config values
    property string text: ""
    property QtObject launcher: QtObject {
        property bool enabled: false
    }
    property QtObject bar: QtObject {
        property bool enabled: false
    }

    // FileView watches and syncs config.json
    property var file: FileView {
        path: Qt.resolvedUrl("../config.json")
        watchChanges: true

        adapter: JsonAdapter {
            id: adapter
            property string text
            property JsonObject launcher: JsonObject {
                property bool enabled: false
            }
            property JsonObject bar: JsonObject {
                property bool enabled: false
            }
        }

        onLoaded: updateFromAdapter()
        onFileChanged: {
            reload()
            Qt.callLater(updateFromAdapter)
        }
    }

    function updateFromAdapter() {
        // sync top-level fields
        Config.text = file.adapter.text
        Config.launcher.enabled = file.adapter.launcher.enabled
        Config.bar.enabled = file.adapter.bar.enabled

        console.log("[Config] Updated:", Config.text, Config.launcher.enabled)
    }

    function reload() {
        file.reload()
    }

    function save() {
        file.adapter.text = Config.text
        file.adapter.launcher.enabled = Config.launcher.enabled
        file.adapter.bar.enabled = Config.bar.enabled
        file.writeAdapter()
    }
}
