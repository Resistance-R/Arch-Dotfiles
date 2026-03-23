import QtQuick

import "../../services" as MyService
import "../../theme" as MyTheme

Item {
    id: root

    signal clicked

    required property bool showIp
    property bool ipShowing: showIp
    property string myIp: ipShowing 
    ? " | " + MyService.NetworkService.ipAddress 
    : ""

    readonly property var wifi_strength: ["\udb82\udd1f", "\udb82\udd22", "\udb82\udd25", "\udb82\udd28"]
    readonly property string network_disconnected: "\udb80\udf19"
    readonly property string ethernet: "\udb80\ude01"

    function networkCheck() {
        if (MyService.NetworkService.networkType === "ethernet") {
            return root.ethernet
        } else if(MyService.NetworkService.networkType === "wifi") {
            const icons = root.wifi_strength.length
            const strength = MyService.NetworkService.strength
            const level = Math.min(icons - 1, Math.floor(strength / (100 / icons)))
            
            return root.wifi_strength[level]
        } else {
            return root.network_disconnected
        }
    }

    implicitWidth: wrapper.implicitWidth
    implicitHeight: wrapper.implicitHeight

    Rectangle {
        id: wrapper

        anchors.centerIn: parent
        implicitHeight: MyTheme.Sizes.topbarElementHeight
        implicitWidth: networkIcon.implicitWidth + 16

        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.widgetSurface

        border.width: MyTheme.Sizes.borderWidth
        border.color: MyTheme.Colors.cyanTransparent

        Text {
            id: networkIcon
            
            anchors.centerIn: parent
            font.pixelSize: MyTheme.Sizes.fontSize
            color: MyTheme.Colors.text
            text: "%1%2"
            .arg(root.networkCheck())
            .arg(root.myIp)
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
