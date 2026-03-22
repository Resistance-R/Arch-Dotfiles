pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property bool enabled: false
    property int barCount: 24 // total bar count
    property var values: [] // Audio data values from Cava
    property string pendingLine: ""
    property int processedLength: 0 // value for not working

    Component.onCompleted: {
        resetValues() // Inital Cava bar reset
    }

    // Cava Data Parser
    function parseFrame(line) {
        let changed = false

        const parts = line.trim().split(";")
        const arr = new Array(root.barCount)

        // parsing data
        for (let i = 0; i < root.barCount; i++) {
            if (i < parts.length) {
                const v = parseInt(parts[i])
                arr[i] = isNaN(v) ? 0 : v
            } else {
                arr[i] = 0
            }
        }

        // threshold
        for (let i = 0; i < root.barCount; i++) {
            if (Math.abs(root.values[i] - arr[i]) >= 3) {
                changed = true
                break
            }
        }
        
        if (changed) {
            root.values = arr
        }
    }

    function resetValues() {
        const arr = new Array(root.barCount)
        for (let i = 0; i < root.barCount; i++)
            arr[i] = 0

        root.values = arr
    }

    function start() {
        if (root.enabled)
            return

        root.enabled = true
        root.pendingLine = ""
        root.processedLength = 0
        root.resetValues()

        if (!cavaProc.running)
            cavaProc.running = true
    }

    function stop() {
        if (!root.enabled)
            return

        if (cavaProc.running)
            cavaProc.running = false

        root.pendingLine = ""
        root.processedLength = 0
        root.resetValues()

        root.enabled = false
    }

    function toggle() {
        if (root.enabled)
            root.stop()
        else
            root.start()
    }

    property var cavaProc: Process {
        id: cavaProc

        running: false

        // execute Cava
        command: [
            "sh",
            "-c",
            "cava -p \"$HOME/.config/cava/config_qs\""
        ]

        stdout: StdioCollector {
            waitForEnd: false

            // Delivery Cava Data
            onTextChanged: {
                const newText = text.slice(root.processedLength)
                root.processedLength = text.length

                if (newText.length === 0)
                    return

                const combined = root.pendingLine + newText
                const lines = combined.split("\n")
                root.pendingLine = lines.pop()

                for (let line of lines) {
                    if (line.length > 0)
                        root.parseFrame(line)
                }
            }

            onStreamFinished: {
                if (root.pendingLine.trim().length > 0)
                    root.parseFrame(root.pendingLine)

                root.pendingLine = ""
                root.processedLength = 0

                if (root.enabled) {
                    console.log("cava exited unexpectedly")
                    root.stop()
                }
            }
        }

        stderr: StdioCollector {
            waitForEnd: false
            onTextChanged: {
                console.log("cava stderr:", text)
            }
        }
    }
}
