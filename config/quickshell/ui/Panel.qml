import Quickshell
import Quickshell.Wayland
import QtQuick 

import "../theme" as MyTheme

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    color: MyTheme.Theme.colors.bg
    implicitHeight: MyTheme.Theme.sizes.barHeight

    Text {
        color: MyTheme.Theme.colors.text
        font.pixelSize: MyTheme.Theme.sizes.fontSize
        text: "hi"
    }
}
