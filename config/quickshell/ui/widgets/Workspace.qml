import QtQuick

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    implicitHeight: workspaceStat.implicitHeight
    implicitWidth: workspaceStat.implicitWidth

    Text {
        id: workspaceStat

        font.pixelSize: MyTheme.Sizes.fontSize
        anchors.centerIn: parent
        color: MyTheme.Colors.text

        text: "[%1/%2] : %3"
            .arg(MyService.WorkspaceService.curWorkspace)
            .arg(MyService.WorkspaceService.maxWs)
            .arg(MyService.WorkspaceService.activeTitle)
    }
}
