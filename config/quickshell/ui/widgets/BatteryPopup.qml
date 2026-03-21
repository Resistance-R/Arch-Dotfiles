import Quickshell
import QtQuick

import "../../services" as MyService
import "../../theme" as MyTheme

PopupWindow {
    id: root

    required property var battery
    required property var popupVisible

    visible: popupVisible

    anchor.item: battery
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: MyTheme.Sizes.widgetHeight + MyTheme.Sizes.gap
    
    color: "transparent"
    
    implicitHeight: content.implicitHeight + MyTheme.Sizes.padding * 2
    implicitWidth: content.implicitWidth + MyTheme.Sizes.padding * 2

    onVisibleChanged: {
        if (visible) {
            MyService.SystemStatsService.start()
            MyService.TopProcessesService.start()
        }
        else {
            MyService.SystemStatsService.stop()
            MyService.TopProcessesService.stop()
        }
    }

    Rectangle {
        id: batteryPopup
        anchors.fill: parent
        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.surface

        Item {
            id: content
            anchors.centerIn: parent

            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
            Column {
                id: column
                spacing: 8

                Text {
                    id: batteryTime

                    font.pixelSize: MyTheme.Sizes.bigFontSize
                    color: MyTheme.Colors.text
                    text: MyService.BatteryService.isCharging
                    ? "Full in: %1h %2m"
                        .arg(MyService.BatteryService.chargingTime_h)
                        .arg(MyService.BatteryService.chargingTime_m)
                    : "Empty in: %1h %2m"
                        .arg(MyService.BatteryService.leftTime_h)
                        .arg(MyService.BatteryService.leftTime_m)
                }

                Text {
                    id: memUsage

                    font.pixelSize: MyTheme.Sizes.fontSize
                    color: MyTheme.Colors.text
                    text: "Mem Usage:\n    "
                    + MyService.SystemStatsService.memoryUsage.toFixed(1) + '%'
                    + " (%1 GiB / %2 GiB)"
                        .arg(MyService.SystemStatsService.memoryUsedGiB.toFixed(2))
                        .arg(MyService.SystemStatsService.memoryTotalGiB.toFixed(2))
                }
                
                Text {
                    id: cpuStats

                    font.pixelSize: MyTheme.Sizes.fontSize
                    color: MyTheme.Colors.text
                    text: "CPU:\n    Usage: "
                    + MyService.SystemStatsService.cpuUsage.toFixed(1) + "%\n"
                    + "    Temperature: "
                    + MyService.SystemStatsService.cpuTemp + "°C"
                }

                Column {
                    id: topProcessesList
                    spacing: 4

                    Text {
                        font.pixelSize: MyTheme.Sizes.fontSize
                        color: MyTheme.Colors.text
                        text: "Power-hungry Processes:"
                    }
                    
                    Repeater {
                        model: MyService.TopProcessesService.topProcesses

                        delegate: Text {
                            font.pixelSize: MyTheme.Sizes.fontSize
                            color: MyTheme.Colors.text
                            text: "    %1. ".arg(index + 1)
                            + modelData.name
                            + " (" + modelData.cpu + "%)"
                        }
                    }
                }
            }
        }
    }
}
