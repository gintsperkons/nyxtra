import qs.modules.launcher





import QtQuick
import QtQuick.Window
import Quickshell



ShellRoot {
LazyLoader { active: true; component: Launcher{} }
}
