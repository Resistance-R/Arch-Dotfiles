import Quickshell
import QtQuick

import "../../services" as MyService
import "../../theme" as MyTheme

PopupWindow {
    id: root

    required property var clock
    required property var popupVisible

    visible: popupVisible

    anchor.item: clock
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: MyTheme.Sizes.widgetHeight + MyTheme.Sizes.gap
    
    color: "transparent"
    
    implicitHeight: content.implicitHeight + MyTheme.Sizes.padding * 2
    implicitWidth: content.implicitWidth + MyTheme.Sizes.padding * 2

    Rectangle {
        id: clockPopup

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

            Text {
                id: calendar

                font.family: "monospace"
                font.pixelSize: MyTheme.Sizes.fontSize
                color: MyTheme.Colors.text
                text: MyService.TimeService.calendarLoading
                ? "Loading..."
                : MyService.TimeService.calendarText

            }
        }
    }
}
