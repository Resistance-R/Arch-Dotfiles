pragma Singleton
import QtQuick
import Quickshell.Services.UPower

QtObject {
    readonly property real percent: Math.round(UPower.displayDevice.percentage * 100)
    readonly property real emptyTime: UPower.displayDevice.timeToEmpty
    readonly property real fullTime: UPower.displayDevice.timeToFull
    readonly property bool isCharging: UPower.onBattery ? false : true

    property real leftTime_h: Math.floor(emptyTime / 3600)
    property real leftTime_m: Math.floor((emptyTime % 3600) / 60)

    property real chargingTime_h: Math.floor(fullTime / 3600)
    property real chargingTime_m: Math.floor((fullTime % 3600) / 60)
}
