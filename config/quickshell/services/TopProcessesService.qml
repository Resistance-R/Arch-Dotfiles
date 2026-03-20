pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property bool enabled: false
    property var topProcesses: []

    // toggle functions
    function start() {
        if (root.enabled)
            return

        root.enabled = true
    }

    function stop() {
        if (!root.enabled)
            return

        root.enabled = false
        root.psProc.running = false
    }

    // execute ps command
    property var psProc: Process {
        command: ["sh", "-c", "ps -eo pid=,comm=,pcpu= --sort=-pcpu | head -n 3"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseProcesses(this.text)
            }
        }
    }

    property var updateTimer: Timer {
        interval: 2000
        running: root.enabled
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.psProc.running = true
        }
    }

    // ps command parser
    function parseProcesses(text) {
        const lines = text.trim().split("\n")
        const result = []

        for (let line of lines) {
            const parts = line.trim().split(/\s+/)
            if (parts.length < 3)
                continue

            const pid = parts[0]
            const cpu = parts[parts.length - 1]
            const name = parts.slice(1, parts.length - 1).join(" ")

            result.push({
                pid: pid,
                name: name,
                cpu: cpu
            })
        }

        root.topProcesses = result
    }
}
