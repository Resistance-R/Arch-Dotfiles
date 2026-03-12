import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../theme" as MyTheme
import "./widgets" as Widgets

PanelWindow {
    id: panel

    property string activePopup: ""

    function togglePopup(name) {
        activePopup = (activePopup === name) ? "" : name
    }

    anchors {
        top: true
        left: true
        right: true
    }

    color: MyTheme.Colors.bg
    implicitHeight: MyTheme.Sizes.barHeight

    RowLayout {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Widgets.Workspace {}
    }
    

    // Center; Clock
    RowLayout {
        anchors.centerIn: parent

        Widgets.Clock {
            panel: panel
            onClicked: panel.togglePopup("clock")
            formatChange: panel.activePopup === "clock"
        }
    }


    // Right side; Network Stat, Audio, Battery, Power
    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Widgets.Battery {
            onClicked: panel.togglePopup("battery")
        }
    }

    Widgets.BatteryPopup {
        panel: panel
        popupVisible: panel.activePopup === "battery"
    }
}
