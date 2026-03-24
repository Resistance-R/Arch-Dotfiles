import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../services" as MyService
import "../../theme" as MyTheme

PopupWindow {
    id: root

    required property var bright
    required property bool popupVisible

    visible: popupVisible
    color: "transparent"

    anchor.item: bright
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: MyTheme.Sizes.widgetHeight + MyTheme.Sizes.gap

    implicitWidth: contentColumn.implicitWidth + MyTheme.Sizes.padding * 2
    implicitHeight: contentColumn.implicitHeight + MyTheme.Sizes.padding * 2

    Rectangle {
        id: brightPopup

        anchors.fill: parent
        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.widgetSurface

        border.width: MyTheme.Sizes.borderWidth
        border.color: MyTheme.Colors.blueTransparent


        Column {
            id: contentColumn

            anchors.centerIn: parent
            spacing: MyTheme.Sizes.gap

            Text {
                color: MyTheme.Colors.text
                font.pixelSize: MyTheme.Sizes.fontSize
                textFormat: Text.StyledText
                text: MyService.BrightnessService.available
                ? "\udb80\udce0 <b>" + MyService.BrightnessService.brightnessPercent + "</b>%"
                : "<b>Unavailable</b>"
            }

            RowLayout {
                spacing: MyTheme.Sizes.gap * 4

                Text {
                    color: MyTheme.Colors.text
                    font.pixelSize: MyTheme.Sizes.bigFontSize
                    text: "\udb80\udf74"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            MyService.BrightnessService.setBrightnessPercent(
                                Math.max(0, brightSlider.value - 5)
                            )
                        }
                    }
                }

                Slider {
                    id: brightSlider

                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    stepSize: 1
                    value: MyService.BrightnessService.available
                        ? MyService.BrightnessService.brightnessPercent
                        : 0

                    onMoved: {
                        MyService.BrightnessService.setBrightnessPercent(value)
                    }

                    background: Rectangle {
                        x: brightSlider.leftPadding
                        y: brightSlider.topPadding + brightSlider.availableHeight / 2 - height / 2
                        implicitWidth: MyTheme.Sizes.sliderWidth
                        implicitHeight: 6
                        radius: 3
                        color: MyTheme.Colors.bgAlt

                        Rectangle {
                            width: brightSlider.visualPosition * parent.width
                            height: parent.height
                            radius: parent.radius
                            color: MyTheme.Colors.cyan
                        }
                    }

                    handle: Rectangle {
                        x: brightSlider.leftPadding + brightSlider.visualPosition * (brightSlider.availableWidth - width)
                        y: brightSlider.topPadding + brightSlider.availableHeight / 2 - height / 2
                        width: 16
                        height: 16
                        radius: width / 2
                        color: MyTheme.Colors.text
                        border.width: 1
                        border.color: Qt.rgba(0, 0, 0, 0.15)
                    }
                }

                Text {
                    color: MyTheme.Colors.text
                    font.pixelSize: MyTheme.Sizes.bigFontSize
                    text: "\udb81\udc15"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            MyService.BrightnessService.setBrightnessPercent(
                                Math.min(100, brightSlider.value + 5)
                            )
                        }
                    }
                }
            }
        }
    }
}
