pragma Singleton
import QtQuick

QtObject {
    id: clock

    property var now: new Date()

    property Item _timerHost: Item {
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                clock.now = new Date()
            }
        }
    }
    function getTimeString(format) {
        return Qt.formatTime(clock.now, format)
    }
    function getDateString(format) {
        return Qt.formatDate(clock.now, format)
    }
}
