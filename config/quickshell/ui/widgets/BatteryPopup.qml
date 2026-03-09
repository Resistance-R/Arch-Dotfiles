import Quickshell
import QtQuick

import "../../services" as MyService
import "../../theme" as MyTheme

// todo:
// - [x] 배터리 팝업 좌우 여백 남기기 (margin)
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

        
        Item {
            id: content
            anchors.centerIn: parent

            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height

            Text {
                font.pixelSize: 16 
                color: MyTheme.Colors.text
                text: MyService.BatteryService.isCharging
                ? "Full in: %1h %2m"
                    .arg(MyService.BatteryService.chargingTime_h)
                    .arg(MyService.BatteryService.chargingTime_m)
                : "Empty in: %1h %2m"
                    .arg(MyService.BatteryService.leftTime_h)
                    .arg(MyService.BatteryService.leftTime_m)
            }
        }
    }
}
