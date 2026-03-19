import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../theme" as MyTheme
import "./widgets" as Widgets

PanelWindow {
    id: root

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

    // Left; Workspace
    RowLayout {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Widgets.Workspace {}
    }
    

    // Center; Clock
    RowLayout {
        anchors.centerIn: parent

        Widgets.Clock {
            id: clockWidget

            onClicked: root.togglePopup("clock")
            formatChange: root.activePopup === "clock"
        }
    }


    // Right; Network Stat, Audio, Battery, Power
    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Widgets.Battery {
            id: batteryWidget
            onClicked: root.togglePopup("battery")
        }
    }

    Widgets.BatteryPopup {
        battery: batteryWidget
        popupVisible: root.activePopup === "battery"
    }

    Widgets.ClockPopup {
        clock: clockWidget
        popupVisible: root.activePopup === "clock"
    }
}
