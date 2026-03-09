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
        anchors.fill: parent
        spacing: MyTheme.Sizes.gap

        // Left side; Workspace
        RowLayout {
            spacing: MyTheme.Sizes.gap
            Text {
                color: MyTheme.Colors.text
                text: "Workspace"
            }
        }
        
        Item { Layout.fillWidth: true } // spacing

        // Center; Clock
        RowLayout {
            Widgets.Clock {
                onClicked: panel.togglePopup("clock")
            }
        }

        Item { Layout.fillWidth: true }

        // Right side; Network Stat, Audio, Battery, Power
        RowLayout {
            Widgets.Battery {
                onClicked: panel.togglePopup("battery")
            }
        }

    }

    Widgets.BatteryPopup {
        panel: panel
        popupVisible: panel.activePopup === "battery"
    }
}
