pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

QtObject {
    id: root

    readonly property bool ready: Pipewire.ready

    // Current Default Output Device
    readonly property var sink: Pipewire.defaultAudioSink

    property var sinkTracker: PwObjectTracker {
        objects: [root.sink]
    }

    readonly property bool connected:
        root.ready &&
        root.sink !== null &&
        root.sink.audio !== null

    property string deviceType: "unknown"

    readonly property string deviceName: {
        if (!root.connected)
            return ""

        if (root.sink.description && root.sink.description.length > 0)
            return root.sink.description

        if (root.sink.nickname && root.sink.nickname.length > 0)
            return root.sink.nickname

        if (root.sink.name && root.sink.name.length > 0)
            return root.sink.name

        return ""
    }

    readonly property real volume: {
        if (!root.connected)
            return 0.0
        return root.sink.audio.volume
    }

    readonly property int volumePercent:
        Math.round(root.volume * 100)

    readonly property bool muted:
        root.connected ? root.sink.audio.muted : false

    function setVolumePercent(percent) {
        if (!root.connected)
            return

        const clamped = Math.max(0, Math.min(100, percent))
        root.sink.audio.volume = clamped / 100.0
    }

    function setMuted(value) {
        if (!root.connected)
            return

        root.sink.audio.muted = value
    }

    function toggleMute() {
        if (!root.connected)
            return

        root.sink.audio.muted = !root.sink.audio.muted
    }

    function parseActivePort(text) {
        if (!root.connected) {
            root.deviceType = "none"
            return
        }

        const lowered = text.toLowerCase()

        if (lowered.includes("analog-output-headphones")) {
            root.deviceType = "headphones"
            return
        }

        if (lowered.includes("analog-output-speaker")) {
            root.deviceType = "speaker"
            return
        }

        root.deviceType = "unknown"
    }

    function refreshPort() {
        if (!root.connected) {
            root.deviceType = "none"
            return
        }

        if (!checkActivePort.running)
            checkActivePort.running = true
    }

    property var checkActivePort: Process {
        command: ["sh", "-c", "pactl list sinks | grep 'Active Port'"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseActivePort(text)
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    console.log("checkActivePort stderr:", text)
            }
        }
    }    

    property var audioEventProc: Process {
        running: true
        command: ["pactl", "subscribe"]

        property string pendingLine: ""

        stdout: StdioCollector {
            waitForEnd: false

            onTextChanged: {
                const combined = root.audioEventProc.pendingLine + text
                const lines = combined.split("\n")

                root.audioEventProc.pendingLine = lines.pop()

                for (let line of lines) {
                    const lowered = line.trim().toLowerCase()

                    if (
                        lowered.includes("on sink") ||
                        lowered.includes("on card") ||
                        lowered.includes("on server")
                    ) {
                        root.refreshPort()
                    }
                }
            }
        }

        stderr: StdioCollector {
            waitForEnd: false

            onTextChanged: {
                if (text.trim().length > 0)
                    console.log("audioEventProc stderr:", text)
            }
        }
    }

    Component.onCompleted: {
        root.refreshPort()
    }

    onReadyChanged: {
        if (root.ready)
            root.refreshPort()
    }

    onConnectedChanged: {
        if (root.connected)
            root.refreshPort()
        else
            root.deviceType = "none"
    }

    onSinkChanged: {
        root.refreshPort()
    }
}
