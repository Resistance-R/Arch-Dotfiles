import QtQuick

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    signal clicked

    required property bool showInfo
    property bool infoShowing: showInfo
    property string info: infoShowing
    ? " | " + MyService.BrightnessService.brightnessPercent + '%'
    : ""

    readonly property var brightenssIcon: ["\udb80\udcdc", "\udb80\udcdb", "\udb80\udcda"]
    readonly property string unavailableIcon: "\uf467"

    function printBrightnessStat() {
        const icons = root.brightenssIcon.length
        const brightness = MyService.BrightnessService.brightnessPercent
        const level = Math.min(icons - 1, Math.floor(brightness / (100 / icons)))

        if (MyService.BrightnessService.available) {
            return root.brightenssIcon[level]
        } else {
            return root.unavailableIcon
        }
    }

    implicitWidth: wrapper.implicitWidth
    implicitHeight: wrapper.implicitHeight

    Rectangle {
        id: wrapper

        anchors.centerIn: parent
        implicitHeight: MyTheme.Sizes.topbarElementHeight
        implicitWidth: brightIcon.implicitWidth + 16

        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.widgetSurface

        border.width: MyTheme.Sizes.borderWidth
        border.color: MyTheme.Colors.cyanTransparent

        clip: true

        Behavior on implicitWidth {
            MyTheme.WidthAnim {}
        }

        Text {
            id: brightIcon
            
            anchors.centerIn: parent
            font.pixelSize: MyTheme.Sizes.fontSize
            textFormat: Text.StyledText
            color: MyTheme.Colors.text

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignHCenter
            elide: Text.ElideRight

            text: "%1%2"
            .arg(root.printBrightnessStat())
            .arg(root.info)
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
