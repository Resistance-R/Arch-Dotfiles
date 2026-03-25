import QtQuick
import Quickshell

import "../../theme" as MyTheme
import "../../services" as MyService

PopupWindow {
    id: root

    required property var network
    required property var popupVisible

    function showNetworkInfo() {
        if (MyService.NetworkService.networkType === "ethernet") {
            return "Ethernet"
        } else if (MyService.NetworkService.networkType === "wifi") {
            return "%1: %2 (%3%)"
                .arg(MyService.NetworkService.device)
                .arg(MyService.NetworkService.ssid)
                .arg(MyService.NetworkService.strength)
        }
    }

    visible: popupVisible

    anchor.item: network
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: MyTheme.Sizes.widgetHeight + MyTheme.Sizes.gap
    
    color: "transparent"
    
    implicitHeight: content.implicitHeight + MyTheme.Sizes.padding * 2
    implicitWidth: content.implicitWidth + MyTheme.Sizes.padding * 2

    MyTheme.FadeAnim {
        target: networkPopup
        visibleState: root.popupVisible
    }

    Rectangle {
        id: networkPopup

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
                    id: networkInfo

                    font.pixelSize: MyTheme.Sizes.bigFontSize
                    color: MyTheme.Colors.text
                    text: MyService.NetworkService.connected
                    ? root.showNetworkInfo()
                    : "Not Connected"
                }
            }
        }
    }
}
