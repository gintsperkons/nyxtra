pragma Singleton
import QtQuick
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

QtObject {
  id: config

  // Top-level config values
  property QtObject launcher: QtObject {
    property bool enabled: false
    property string backgroundColor: "#112233"
    property string borderColor: "#111111"
    property string cursorColor: "#223344"
    property string textColor: "#ffffff"
  }
  property QtObject bar: QtObject {
    property bool enabled: false
    property string clockFormatShort: "HH:mm"
  }

  // FileView watches and syncs config.json
  property var file: FileView {
    path: Qt.resolvedUrl("../config.json")
    watchChanges: true

    adapter: JsonAdapter {
      id: adapter
      property JsonObject launcher: JsonObject {
        property bool enabled
        property string backgroundColor
        property string borderColor
        property string cursorColor
        property string textColor
      }
      property JsonObject bar: JsonObject {
        property bool enabled
        property string clockFormatShort
      }
    }

    onLoaded: updateFromAdapter()
    onFileChanged: {
      reload()
      Qt.callLater(updateFromAdapter)
    }
  }

  function mergeConfig(target, source) {
    for (let key in source) {
      // Skip internal Qt properties and signals
      if (!target.hasOwnProperty(key)) continue;
      if (key.endsWith("Changed") || key.startsWith("_")) continue;

      let value = source[key];

      if (value === undefined || typeof value === "function")
          continue;

      // Recurse for nested objects
      if (typeof value === "object" && value !== null) {
          mergeConfig(target[key], value);
      } else {
          target[key] = value;
      }
    }
  }


  function updateFromAdapter() {
      mergeConfig(Config.launcher, file.adapter.launcher)
      mergeConfig(Config.bar, file.adapter.bar)
  }


  function reload() {
    file.reload()
  }


  //add export to the menu items
}
