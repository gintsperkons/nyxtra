import QtQuick
pragma Singleton

QtObject {
    readonly property QtObject route: QtObject {
        id: route
        readonly property string launcher: "launcher"
        readonly property string applicationsMenu: "applications"
        readonly property string powerMenu: "power"
    }
}
