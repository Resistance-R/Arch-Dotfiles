import QtQuick

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    signal clicked

    implicitHeight: wrapper.implicitHeight
    implicitWidth: wrapper.implicitWidth

    Rectangle {
        id: wrapper

        implicitHeight: MyTheme.Sizes.topbarElementHeight
        implicitWidth: 48

        radius: MyTheme.Sizes.radius * 5
        color: MyTheme.Colors.widgetSurface
        clip: true

        property string label: MyService.BatteryService.isCharging
            ? "\udb85\udc0b"
            : MyService.BatteryService.percent

        Rectangle {
            id: fillBar

            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }

            width: parent.width * MyService.BatteryService.percent / 100
            radius: parent.radius
            color: MyService.BatteryService.isCharging
            ? MyTheme.Colors.green
            : MyTheme.Colors.text
        }

        // Light text shown in background
        Text {
            id: lightText

            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: MyTheme.Sizes.fontSize
            font.bold: true
            color: MyTheme.Colors.text
            text: wrapper.label
        }

        // Dark text shown in fill area
        Item {
            id: fillClip
            anchors.fill: fillBar
            clip: true

            Text {
                x: lightText.x - fillClip.x
                y: lightText.y - fillClip.y
                width: lightText.width
                height: lightText.height

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: lightText.font.pixelSize
                font.bold: lightText.font.bold
                color: MyTheme.Colors.bgAlt
                text: wrapper.label
            }
        }

        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.10)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}

