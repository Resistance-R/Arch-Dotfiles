pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property bool available: false
    property string devicePath: ""
    property int actualBrightness: 0
    property int maxBrightness: 0

    readonly property int brightnessPercent:
        (root.available && root.maxBrightness > 0)
            ? Math.round(root.actualBrightness / root.maxBrightness * 100)
            : 0

    function detectBacklightDevice(output) {
        const lines = output.trim().split("\n").filter(line => line.length > 0)

        if (lines.length === 0) {
            root.available = false
            root.devicePath = ""
            return
        }

        // Use the First Device
        root.devicePath = "/sys/class/backlight/" + lines[0]
        root.available = true

        root.refresh()
    }

    function parseActualBrightness(output) {
        const v = parseInt(output.trim())
        root.actualBrightness = isNaN(v) ? 0 : v
    }

    function parseMaxBrightness(output) {
        const v = parseInt(output.trim())
        root.maxBrightness = isNaN(v) ? 0 : v
    }

    function refresh() {
        if (!root.available || root.devicePath.length === 0)
            return

        readActualProc.command = ["cat", root.devicePath + "/actual_brightness"]
        readMaxProc.command = ["cat", root.devicePath + "/max_brightness"]

        readActualProc.running = true
        readMaxProc.running = true
    }

    function setBrightnessPercent(percent) {
        if (!root.available)
            return

        const clamped = Math.max(1, Math.min(100, Math.round(percent)))

        setBrightnessProc.command = ["brightnessctl", "set", clamped + "%"]
        setBrightnessProc.running = true
    }

    property var detectDeviceProc: Process {
        command: ["sh", "-c", "ls /sys/class/backlight"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.detectBacklightDevice(text)
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0) {
                    root.available = false
                    root.devicePath = ""
                }
            }
        }
    }

    property var readActualProc: Process {
        command: ["cat", ""]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseActualBrightness(text)
            }
        }
    }

    property var readMaxProc: Process {
        command: ["cat", ""]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseMaxBrightness(text)
            }
        }
    }

    property var setBrightnessProc: Process {
        command: ["brightnessctl", "set", "50%"]

        stdout: StdioCollector {}
        stderr: StdioCollector {}
    }

    // Event-based monitor
    property var backlightEventProc: Process {
        running: true
        command: ["udevadm", "monitor", "--kernel", "--subsystem-match=backlight"]

        property string pendingLine: ""

        stdout: StdioCollector {
            waitForEnd: false

            onTextChanged: {
                const combined = root.backlightEventProc.pendingLine + text
                const lines = combined.split("\n")
                root.backlightEventProc.pendingLine = lines.pop()

                for (let line of lines) {
                    const lowered = line.trim().toLowerCase()
                    if (lowered.includes("backlight")) {
                        root.refresh()
                    }
                }
            }
        }

        stderr: StdioCollector {
            waitForEnd: false
        }
    }

    Component.onCompleted: {
        root.detectDeviceProc.running = true
    }
}
