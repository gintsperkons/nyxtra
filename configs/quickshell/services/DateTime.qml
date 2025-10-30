pragma Singleton
import QtQuick

QtObject {
    id: clock

    property string timeString: Qt.formatTime(new Date(), "hh:mm:ss")
    property string dateString: Qt.formatDate(new Date(), "yyyy-MM-dd")
    property var now: new Date()

    property Item _timerHost: Item {
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                clock.now = new Date()
                clock.timeString = Qt.formatTime(clock.now, "hh:mm:ss")
                clock.dateString = Qt.formatDate(clock.now, "yyyy-MM-dd")
            }
        }
    }
}
