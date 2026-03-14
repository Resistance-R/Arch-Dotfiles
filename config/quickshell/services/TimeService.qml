pragma Singleton
import QtQuick

QtObject {
    id: myTime

    property date now: new Date()

    property var ticker: Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: myTime.now = new Date()
    }
}
