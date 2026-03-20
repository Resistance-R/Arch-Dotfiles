pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root
    
    property bool enabled: false

    // ===== Public properties =====
    property real memoryUsage: 0
    property real memoryUsedGiB: 0
    property real memoryTotalGiB: 0

    property real cpuUsage: 0
    property real cpuTemp: 0

    // CPU usage 계산용 이전 상태
    property var prevCpu: null

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

        root.meminfoProc.running = false
        root.cpustatProc.running = false
        root.cputempProc.running = false
    }

    function workToggle() {
        if (root.enabled)
            root.stop()
        else
            root.start()
    }

    // ===== Memory =====
    property var meminfoProc: Process {
        command: ["cat", "/proc/meminfo"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseMemory(this.text)
            }
        }
    }

    // ===== CPU stat =====
    property var cpustatProc: Process {
        command: ["cat", "/proc/stat"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseCpu(this.text)
            }
        }
    }

    // ===== CPU temperature =====
    property var cputempProc: Process {
        command: ["cat", "/sys/class/thermal/thermal_zone0/temp"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseTemperature(this.text)
            }
        }
    }

    // ===== Update timer =====
    property var updateTimer: Timer {
        interval: 2000
        running: root.enabled
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.meminfoProc.running = true
            root.cpustatProc.running = true
            root.cputempProc.running = true
        }
    }

    function parseMemory(text) {
        const lines = text.split("\n")

        let total = 0
        let available = 0

        for (let line of lines) {
            if (line.startsWith("MemTotal:"))
                total = parseInt(line.split(/\s+/)[1])

            if (line.startsWith("MemAvailable:"))
                available = parseInt(line.split(/\s+/)[1])
        }

        if (total > 0) {
            const used = total - available
            root.memoryUsage = used / total * 100
            root.memoryUsedGiB = used / 1024 / 1024
            root.memoryTotalGiB = total / 1024 / 1024
        }
    }

    function parseCpu(text) {
        const firstLine = text.split("\n")[0]
        const parts = firstLine.trim().split(/\s+/)

        const user = parseInt(parts[1]) || 0
        const nice = parseInt(parts[2]) || 0
        const system = parseInt(parts[3]) || 0
        const idle = parseInt(parts[4]) || 0
        const iowait = parseInt(parts[5]) || 0
        const irq = parseInt(parts[6]) || 0
        const softirq = parseInt(parts[7]) || 0
        const steal = parseInt(parts[8]) || 0

        const idleAll = idle + iowait
        const nonIdle = user + nice + system + irq + softirq + steal
        const total = idleAll + nonIdle

        if (root.prevCpu !== null) {
            const totalDiff = total - root.prevCpu.total
            const idleDiff = idleAll - root.prevCpu.idle

            if (totalDiff > 0)
                root.cpuUsage = (totalDiff - idleDiff) / totalDiff * 100
        }

        root.prevCpu = {
            idle: idleAll,
            total: total
        }
    }

    function parseTemperature(text) {
        const raw = parseInt(text.trim())

        if (!isNaN(raw))
            root.cpuTemp = raw / 1000
    }
}
