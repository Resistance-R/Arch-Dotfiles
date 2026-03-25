import QtQuick

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    property string title: (MyService.WorkspaceService.activeTitle === "Null")
    ? ""
    : " : " + MyService.WorkspaceService.activeTitle

    implicitHeight: wrapper.implicitHeight
    implicitWidth: wrapper.implicitWidth


    Rectangle {
        id: wrapper

        anchors.centerIn: parent
        implicitHeight: MyTheme.Sizes.topbarElementHeight
        implicitWidth: workspaceStat.implicitWidth + 16

        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.widgetSurface
        
        border.width: MyTheme.Sizes.borderWidth
        border.color: MyTheme.Colors.purpleTransparent

        clip: true

        Behavior on implicitWidth {
            MyTheme.WidthAnim {}
        }

        Text {
            id: workspaceStat

            font.pixelSize: MyTheme.Sizes.fontSize
            anchors.centerIn: parent
            color: MyTheme.Colors.text
            textFormat: Text.StyledText

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            text: "[ %1/%2 ] %3"
                .arg("<b>" + MyService.WorkspaceService.curWorkspace + "</b>")
                .arg("<b>" + MyService.WorkspaceService.maxWs + "</b>")
                .arg(root.title)
        }
    }
}
