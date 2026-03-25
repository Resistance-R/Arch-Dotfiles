pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    property var poweroffProc: Process {
        command: ["systemctl", "poweroff"]
    }

    property var rebootProc: Process {
        command: ["systemctl", "reboot"]
    }

    property var logoutProc: Process {
        command: ["hyprctl", "dispatch", "exit"]
    }

    property var lockProc: Process {
        command: ["hyprlock"]
    }
}
