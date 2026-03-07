pragma Singleton
import QtQuick
import Quickshell.Services.UPower

QtObject {
    readonly property real percent: (UPower.displayDevice.percentage * 100)
    readonly property bool is_charging: UPower.onBattery ? false : true
}
