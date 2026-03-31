import QtQuick
import Quickshell
import Quickshell.Hyprland

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    GlobalShortcut {
        name: "powerMenu"
        onPressed: {
            root.pendingAction = ""
            root.popupOpen = !root.popupOpen
        }
    }

    property bool popupOpen: false
    property string pendingAction: ""
    property string pendingLabel: ""
    
    function requestAction(action, label) {
        if (root.pendingAction === action) {
            root.confirmAction()
            return
        }

        root.pendingAction = action
        root.pendingLabel = label
    }

    function cancelAction() {
        root.pendingAction = ""
        root.pendingLabel = ""
    }

    function confirmAction() {
        if (root.pendingAction === "poweroff")
            MyService.PowerService.poweroffProc.running = true
        else if (root.pendingAction === "reboot")
            MyService.PowerService.rebootProc.running = true
        else if (root.pendingAction === "logout")
            MyService.PowerService.logoutProc.running = true
        else if (root.pendingAction === "lock")
            MyService.PowerService.lockProc.running = true

        root.cancelAction()
        root.popupOpen = false
    }

    implicitWidth: wrapper.implicitWidth
    implicitHeight: wrapper.implicitHeight

    Rectangle {
        id: wrapper

        anchors.centerIn: parent
        implicitHeight: MyTheme.Sizes.topbarElementHeight
        implicitWidth: powerIcon.implicitWidth + 16

        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.widgetSurface

        border.width: MyTheme.Sizes.borderWidth
        border.color: MyTheme.Colors.cyanTransparent

        Text {
            id: powerIcon
            anchors.centerIn: parent
            color: MyTheme.Colors.text
            font.pixelSize: MyTheme.Sizes.fontSize
            text: "\udb81\udc25"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.cancelAction()
                root.popupOpen = !root.popupOpen
            }
        }
    }

    property var popup: PanelWindow {
        id: powerPopup

        visible: root.popupOpen
        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Rectangle {
            anchors.fill: parent
            color: MyTheme.Colors.bgTransparent

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (root.pendingAction === "")
                        root.popupOpen = false
                    else
                        root.cancelAction()
                } 
            }

            Rectangle {
                id: menuBox

                anchors.centerIn: parent
                width: 260
                height: 220
                radius: MyTheme.Sizes.radius
                color: MyTheme.Colors.widgetSurface
                border.width: MyTheme.Sizes.borderWidth
                border.color: MyTheme.Colors.purpleTransparent

                Column {
                    anchors.centerIn: parent
                    spacing: MyTheme.Sizes.gap * 2

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: MyTheme.Colors.text
                        font.pixelSize: MyTheme.Sizes.bigFontSize
                        font.bold: true
                        text: "Power Menu"
                    }

                    Row {
                        spacing: MyTheme.Sizes.gap * 2
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle {
                            width: MyTheme.Sizes.powerButtonsLength
                            height: MyTheme.Sizes.powerButtonsLength
                            radius: MyTheme.Sizes.powerButtonsRadius
                            color: root.pendingAction === "poweroff"
                                ? MyTheme.Colors.redTransparent
                                : MyTheme.Colors.bgAlt

                            border.width: MyTheme.Sizes.borderWidth
                            border.color: MyTheme.Colors.redTransparent

                            Text {
                                anchors.centerIn: parent
                                color: MyTheme.Colors.text
                                font.pixelSize: MyTheme.Sizes.bigFontSize
                                text: "\udb81\udc25"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.requestAction("poweroff", "Power Off")
                                }
                            }
                        }

                        Rectangle {
                            width: MyTheme.Sizes.powerButtonsLength
                            height: MyTheme.Sizes.powerButtonsLength
                            radius: MyTheme.Sizes.powerButtonsRadius
                            color: root.pendingAction === "reboot"
                                ? MyTheme.Colors.redTransparent
                                : MyTheme.Colors.bgAlt

                            border.width: MyTheme.Sizes.borderWidth
                            border.color: MyTheme.Colors.redTransparent


                            Text {
                                anchors.centerIn: parent
                                color: MyTheme.Colors.text
                                font.pixelSize: MyTheme.Sizes.bigFontSize
                                text: "\udb81\udf09"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.requestAction("reboot", "Reboot")
                                }
                            }
                        }

                        Rectangle {
                            width: MyTheme.Sizes.powerButtonsLength
                            height: MyTheme.Sizes.powerButtonsLength
                            radius: MyTheme.Sizes.powerButtonsRadius
                            color: root.pendingAction === "logout"
                                ? MyTheme.Colors.yellowTransparent
                                : MyTheme.Colors.bgAlt

                            border.width: MyTheme.Sizes.borderWidth
                            border.color: MyTheme.Colors.yellowTransparent

                            Text {
                                anchors.centerIn: parent
                                color: MyTheme.Colors.text
                                font.pixelSize: MyTheme.Sizes.bigFontSize
                                text: "\udb80\udf43"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.requestAction("logout", "Logout")
                                }
                            }
                        }

                        Rectangle {
                            width: MyTheme.Sizes.powerButtonsLength
                            height: MyTheme.Sizes.powerButtonsLength
                            radius: MyTheme.Sizes.powerButtonsRadius
                            color: root.pendingAction === "lock"
                                ? MyTheme.Colors.greenTransparent
                                : MyTheme.Colors.bgAlt

                            border.width: MyTheme.Sizes.borderWidth
                            border.color: MyTheme.Colors.greenTransparent

                            Text {
                                anchors.centerIn: parent
                                color: MyTheme.Colors.text
                                font.pixelSize: MyTheme.Sizes.bigFontSize
                                text: "\udb80\udf3e"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.requestAction("lock", "Lock")
                                }
                            }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: MyTheme.Colors.text
                        font.pixelSize: MyTheme.Sizes.fontSize
                        textFormat: Text.StyledText
                        text: root.pendingAction !== ""
                            ? "Are you sure about <b>" + root.pendingLabel + "</b>?"
                            : "Click outside to close"
                    }
                }
            }
        }
    }
}
