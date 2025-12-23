import QtQuick
import Quickshell
import qs
pragma Singleton

QtObject {
    id: root

    property bool barShow: true

    property QtObject route: Route {}
}
