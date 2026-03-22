import QtQuick

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    implicitHeight: wrapper.implicitHeight
    implicitWidth: wrapper.implicitWidth

    Rectangle {
        id: wrapper

        anchors.centerIn: parent
        implicitHeight: MyTheme.Sizes.topbarElementHeight
        implicitWidth: workspaceStat.implicitWidth + 16

        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.widgetSurface
        
        border.width: 1
        border.color: MyTheme.Colors.purpleTransparent

        Text {
            id: workspaceStat

            font.pixelSize: MyTheme.Sizes.fontSize
            anchors.centerIn: parent
            color: MyTheme.Colors.text
            textFormat: Text.RichText

            text: "[ <b>%1</b>/<b>%2</b> ] : %3"
                .arg(MyService.WorkspaceService.curWorkspace)
                .arg(MyService.WorkspaceService.maxWs)
                .arg(MyService.WorkspaceService.activeTitle)
        }
    }
}
