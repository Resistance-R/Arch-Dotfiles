pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property bool connected: false
    property string networkType: "none"
    property string ssid: ""
    property int strength: 0
    property string ipAddress: ""
    property string device: ""

    function parseNetworkStats(output) {
        const lines = output.split("\n")

        for (let line of lines) {
            const [device, type, state] = line.split(":")
            const parts = line.split(":")

            if (!line || line.length === 0) {
                continue
            }

            if (parts.length < 3) {
                continue
            }

            if (state.startsWith("connected") &&
                (type === "wifi" || type === "ethernet")) {

                root.device = device
                root.networkType = type
                root.connected = true

                root.checkIp.running = true

                return
            }
        }

        root.connected = false
        root.networkType = "none"
        root.device = ""
        root.ipAddress = ""
    }

    function parseSSID(output) {
        const lines = output.split("\n")

        for (let line of lines) {
            const [active, ssid, signal] = line.split(':')
            const parts = line.split(":")

            if (!line || line.length === 0) {
                continue
            }

            if (parts.length < 3) {
                continue
            }

            if (active.startsWith("yes")) {
                root.ssid = ssid
                root.strength = parseInt(signal) || 0

                return
            }
        }

        root.ssid = "none"
        root.strength = 0
    }

    function parseIp(output) {
        if (!root.device || root.device.length === 0) {
            root.ipAddress = ""
            return
        }

        var match = output.match(/:(\d+\.\d+\.\d+\.\d+)/)
        root.ipAddress = match ? match[1] : ""

        return
    }

    property var checkNetworkStats: Process {
        command: ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE", "dev"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseNetworkStats(this.text)
            }
        }
    }

    property var checkSSID: Process {
        command: ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL", "dev", "wifi"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseSSID(this.text)
            }
        }
    }

    property var checkIp: Process {
        command: ["nmcli", "-t", "-f", "IP4.ADDRESS", "dev", "show", root.device]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseIp(this.text)
            }
        }
    }

    property var updateTimer: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.checkNetworkStats.running = true

            if (root.networkType === "wifi") {
                root.checkSSID.running = true
            } else {
                root.ssid = ""
                root.strength = 0
            }
        }
    }
}
