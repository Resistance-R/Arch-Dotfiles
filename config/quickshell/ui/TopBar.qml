import Quickshell
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

    MouseArea {
        anchors.fill: parent
        enabled: root.activePopup !== ""
        onClicked: root.activePopup = ""
    }

    anchors {
        top: true
        left: true
        right: true
    }

    color: MyTheme.Colors.bgTransparent
    implicitHeight: MyTheme.Sizes.barHeight

    // Left; Workspace
    RowLayout {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: MyTheme.Sizes.padding

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
        spacing: MyTheme.Sizes.padding

        Widgets.Network {
            id: networkWidget

            onClicked: root.togglePopup("network")
            showIp: root.activePopup === "network"
        }

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

    Widgets.NetworkPopup {
        network: networkWidget
        popupVisible: root.activePopup === "network"
    }
}
