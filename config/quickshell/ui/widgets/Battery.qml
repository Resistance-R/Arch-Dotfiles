import QtQuick
import "../../theme" as MyTheme
import "../../services" as MyService

Text {
    color: MyTheme.Colors.text
    text: MyService.BatteryService.percent + '%'
}
