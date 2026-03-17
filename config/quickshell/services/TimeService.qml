pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property date now: new Date()
    property string calendarText: ""
    property bool calendarLoading: false

    property var ticker: Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }

    function reflashCalendar() {
        if (calProc.running)
            return

        calendarLoading = true
        calProc.running = true
    }

    property var calProc: Process{
        command: ["cal"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.calendarText = text
                root.calendarLoading = false
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0) {
                    root.calendarText = "failed to load calendar"
                    root.calendarLoading = false
                }
            }
        }
    }
}
