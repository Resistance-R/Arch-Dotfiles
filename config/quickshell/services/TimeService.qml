pragma Singleton
import QtQuick

QtObject {
    id: root

    property date now: new Date()

    property var ticker: Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }
}
