import QtQuick

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    signal clicked

    implicitHeight: batteryText.implicitHeight
    implicitWidth: batteryText.implicitWidth

    Text {
        id: batteryText

        anchors.centerIn: parent
        font.pixelSize: MyTheme.Sizes.fontSize
        color: MyTheme.Colors.text
        text: MyService.BatteryService.isCharging
        ? "Charging"
        : MyService.BatteryService.percent + '%'
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}

