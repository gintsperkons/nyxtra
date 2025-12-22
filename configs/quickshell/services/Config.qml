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
    property bool enabled: true
    property string backgroundColor: "#112233"
    property string borderColor: "#111111"
    property string cursorColor: "#223344"
    property string textColor: "#ffffff"
    property string textColorSecondary: "#777777"
  }
  property QtObject bar: QtObject {
    property bool enabled: true
    property string clockFormatShort: "HH:mm"
  }

  // FileView watches and syncs config.json
  property var file: FileView {
    path: Qt.resolvedUrl("../config.json")
    watchChanges: true

    adapter: JsonAdapter {
      id: adapter
      property JsonObject launcher: JsonObject {
        property bool enabled: launcher.enabled
        property string backgroundColor
        property string borderColor
        property string cursorColor
        property string textColor
        property string textColorSecondary
      }
      property JsonObject bar: JsonObject {
        property bool enabled: launcher.enabled
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
      if (!source) return;

      for (let key in source) {
          // skip internal Qt properties
          if (!target.hasOwnProperty(key)) continue;
          if (key.endsWith("Changed") || key.startsWith("_")) continue;

          let value = source[key];

          // skip functions
          if (typeof value === "function") continue;

          // skip null or undefined
          if (value === null || value === undefined) continue;

          // optionally skip empty strings
          if (typeof value === "string" && value.trim() === "") continue;
1
          console.log(value)

          // merge objects recursively
          if (typeof value === "object") {
              if (target[key] === null || target[key] === undefined) {
                  target[key] = {};
              }
              mergeConfig(target[key], value);
          } else {
              // only assign if different
              console.log(`Setting ${key} to ${value}`);
              target[key] = value;
          }
      }
  }



  function updateFromAdapter() {
      mergeConfig(config.launcher, file.adapter.launcher)
      mergeConfig(config.bar, file.adapter.bar)
  }


  function reload() {
    file.reload()
  }


  //add export to the menu items
}
