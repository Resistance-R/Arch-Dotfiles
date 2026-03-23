import QtQuick

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    signal clicked

    required property bool showInfo
    property bool infoShowing: showInfo
    property string info: infoShowing
    ? " | " + MyService.AudioService.volumePercent + '%'
    : ""

    readonly property var volumIcons: ["", "<b>·</b>", "<b>··<b/>", "<b>···</b>"]
    readonly property string muteIcon: "\udb81\udd81"
    readonly property string headphonesIcon: "\udb80\udecb"
    readonly property string speakerIcon: "\udb81\udd7f"
    readonly property string unknownIcon: "\udb85\udd22"

    function printOutputStat() {
        if (MyService.AudioService.muted)
            return root.muteIcon

        const icons = root.volumIcons.length
        const vol = MyService.AudioService.volumePercent
        const level = Math.min(icons - 1, Math.floor(vol / (100 / icons)))

        if (MyService.AudioService.deviceType === "headphones") {
            return root.headphonesIcon + "  " + root.volumIcons[level]
        } else if (MyService.AudioService.deviceType === "speaker") {
            
            return root.speakerIcon + "  " + root.volumIcons[level]
        } else {
            return root.unknownIcon
        }
    }

    implicitWidth: wrapper.implicitWidth
    implicitHeight: wrapper.implicitHeight

    Rectangle {
        id: wrapper

        anchors.centerIn: parent
        implicitHeight: MyTheme.Sizes.topbarElementHeight
        implicitWidth: audioIcon.implicitWidth + 16

        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.widgetSurface

        border.width: MyTheme.Sizes.borderWidth
        border.color: MyTheme.Colors.cyanTransparent

        Text {
            id: audioIcon
            
            anchors.centerIn: parent
            font.pixelSize: MyTheme.Sizes.fontSize
            textFormat: Text.StyledText
            color: MyTheme.Colors.text
            text: "%1%2"
            .arg(root.printOutputStat())
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
