import Quickshell
import QtQuick

import "../../services" as MyService
import "../../theme" as MyTheme

PopupWindow {
    id: root

    required property var battery
    required property var popupVisible

    function makeBar(percent, width) {
        const clamped = Math.max(0, Math.min(100, percent))
        const filled = Math.round(clamped / 100 * width)
        const empty = width - filled

        return "["
            + "#".repeat(filled)
            + "-".repeat(empty)
            + "]"
    }

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

    MyTheme.FadeAnim {
        target: batteryPopup
        visibleState: root.popupVisible
    }

    Rectangle {
        id: batteryPopup

        anchors.fill: parent
        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.surfaceTransparent

        border.width: MyTheme.Sizes.borderWidth
        border.color: MyTheme.Colors.blueTransparent

        Item {
            id: content

            anchors.centerIn: parent

            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height

            Column {
                id: column
                spacing: MyTheme.Sizes.padding

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

                Rectangle {
                    /* Separator */
                    width: MyTheme.Sizes.separatorWidth
                    height: MyTheme.Sizes.separatorHeight
                    radius: MyTheme.Sizes.radius

                    color: MyTheme.Colors.separator
                }

                Text {
                    id: batteryIcon

                    font.pixelSize: MyTheme.Sizes.fontSize
                    font.family: "monospace"
                    color: MyTheme.Colors.cyan
                    text: "Battery: "
                }

                Row {
                    id: batteryFamily

                    Text {
                        id: batteryBar

                        
                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.green
                        text: "     " + 
                        root.makeBar(MyService.BatteryService.percent, 12)
                    }

                    Text {
                        id: batteryStat

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.text
                        text: "%1 %2"
                            .arg(MyService.BatteryService.percent + "%")
                            .arg( (MyService.BatteryService.isCharging)
                                ? "\udb85\udc0b"
                                : "\udb84\udea3")
                    }
                }

                Row {
                    id: memFamily

                    Text {
                        id: memIcon

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.cyan
                        text: "Mem: "
                    }

                    Text {
                        id: memBar

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.red
                        text: root.makeBar(MyService.SystemStatsService.memoryUsage, 12) + "\n"
                    }

                    Text {
                        id: memPercent

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.text
                        text: MyService.SystemStatsService.memoryUsage.toFixed(1) + "%\n"
                    }
                }

                Text {
                    id: memGiB

                    font.pixelSize: MyTheme.Sizes.fontSize
                    font.family: "monospace"
                    textFormat: Text.StyledText
                    color: MyTheme.Colors.text
                    text: "<pre>     └ <b>%1</b> / <b>%2</b> (GiB)</pre>"
                        .arg(MyService.SystemStatsService.memoryUsedGiB.toFixed(2))
                        .arg(MyService.SystemStatsService.memoryTotalGiB.toFixed(2))
                }
                
                Row {
                    id: cpuFamily

                    Text {
                        id: cpuIcon

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.cyan
                        text: "CPU: "
                    }
                    
                    Text {
                        id: cpuBar

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.yellow
                        text: root.makeBar(MyService.SystemStatsService.cpuUsage, 12)
                    }

                    Text {
                        id: cpuPercent

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.text
                        text: MyService.SystemStatsService.cpuUsage.toFixed(1) + "%"
                    }
                }

                Row {
                    id: cpuSub

                    Text {
                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        textFormat: Text.StyledText
                        color: MyTheme.Colors.text

                        text: "<pre>     └ \uf2c9: </pre>"
                    }

                    Text {
                        id: cpuTempBar

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.yellow
                        text: root.makeBar(MyService.SystemStatsService.cpuTemp, 10)
                    }

                    Text {
                        id: cpuTemp

                        font.pixelSize: MyTheme.Sizes.fontSize
                        font.family: "monospace"
                        color: MyTheme.Colors.text
                        text: MyService.SystemStatsService.cpuTemp + "°C"
                    }
                }

                Rectangle {
                    /* Separator */
                    width: MyTheme.Sizes.separatorWidth
                    height: MyTheme.Sizes.separatorHeight
                    radius: MyTheme.Sizes.radius

                    color: MyTheme.Colors.separator
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
