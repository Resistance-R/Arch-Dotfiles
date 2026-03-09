import Quickshell
import QtQuick

import "../../services" as MyService
import "../../theme" as MyTheme

// todo:
// - [ ] 배터리 팝업 좌우 여백 남기기 (margin)
// - [ ] 하드웨어 상태 나타내는 기능 추가
//    - Memory Usage, CPU Usage / Temperature
// - [ ] 에너지를 많이 사용하는 프로세스 top 3 표시, 얼마나 많이 사용하는지

PopupWindow {
    id: root

    required property var panel
    required property var popupVisible

    visible: popupVisible
    anchor.window: panel
    anchor.rect.x: panel.width - width - MyTheme.Sizes.padding
    anchor.rect.y: panel.height + MyTheme.Sizes.gap
    
    color: "transparent"
    
    implicitHeight: content.implicitHeight + MyTheme.Sizes.padding * 2
    implicitWidth: content.implicitWidth + MyTheme.Sizes.padding * 2


    Rectangle {
        id: batteryPopup
        anchors.fill: parent
        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.surface

        property real batteryTime_h: Math.floor(MyService.BatteryService.emptyTime / 3600)
        property real batteryTime_m: Math.floor((MyService.BatteryService.emptyTime % 3600) / 60)

        Item {
            id: content
            anchors.centerIn: parent

            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height

            Text {
                font.pixelSize: 16 
                color: MyTheme.Colors.text
                text: "Empty in: "
                        + batteryPopup.batteryTime_h + 'h '
                        + batteryPopup.batteryTime_m + 'm'
            }
        }
    }
}
