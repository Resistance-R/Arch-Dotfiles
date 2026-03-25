import Quickshell
import QtQuick
import QtQuick.Layouts

import "../theme" as MyTheme
import "../services" as MyService
import "./widgets" as Widgets

PanelWindow {
    id: root
    
    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: MyTheme.Sizes.barHeight
    color: MyTheme.Colors.bgTransparent


    RowLayout {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    RowLayout {
        anchors.centerIn: parent

        Widgets.Cava {
            barWidth: root.width
            values: MyService.CavaService.values
            active: MyService.CavaService.enabled
        }       
    }

    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Widgets.Power {}
    }

}
