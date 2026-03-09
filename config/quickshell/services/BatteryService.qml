pragma Singleton
import QtQuick
import Quickshell.Services.UPower

QtObject {
    readonly property real percent: Math.round(UPower.displayDevice.percentage * 100)
    readonly property real emptyTime: UPower.displayDevice.timeToEmpty
    readonly property bool isCharging: UPower.onBattery ? false : true
}
