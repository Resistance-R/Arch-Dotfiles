import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../services" as MyService
import "../../theme" as MyTheme

PopupWindow {
    id: root

    required property var audio
    required property bool popupVisible

    visible: popupVisible
    color: "transparent"

    anchor.item: audio
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: MyTheme.Sizes.widgetHeight + MyTheme.Sizes.gap

    implicitWidth: contentColumn.implicitWidth + MyTheme.Sizes.padding * 2
    implicitHeight: contentColumn.implicitHeight + MyTheme.Sizes.padding * 2

    Rectangle {
        id: audioPopup

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
                font.bold: true
                text: MyService.AudioService.deviceName.length > 0
                    ? MyService.AudioService.deviceName
                    : "No Audio Device"
            }

            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                width: parent.width

                Text {
                    id: volPercent

                    color: MyTheme.Colors.text
                    font.pixelSize: MyTheme.Sizes.fontSize
                    textFormat: Text.StyledText
                    text: MyService.AudioService.muted
                        ? "<s>%1%</s> \udb80\udc54 <b>MUTED</b>"
                            .arg("<b>" + MyService.AudioService.volumePercent + "</b>")
                        : "%1%"
                            .arg("<b>" + MyService.AudioService.volumePercent + "</b>")
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    id: muteButton

                    implicitWidth: muteButtonText.implicitWidth + 12
                    implicitHeight: muteButtonText.implicitHeight + 8
                    radius: MyTheme.Sizes.radius
                    color: MyTheme.Colors.bg

                    Text {
                        id: muteButtonText

                        anchors.centerIn: parent
                        color: MyTheme.Colors.text
                        font.pixelSize: MyTheme.Sizes.fontSize
                        text: MyService.AudioService.muted ? "\udb81\udd7f" : "\udb81\udd81"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: MyService.AudioService.toggleMute()
                    }
                }
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
                            MyService.AudioService.setVolumePercent(
                                Math.max(0, volumeSlider.value - 5)
                            )
                        }
                    }
                }

                Slider {
                    id: volumeSlider

                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    stepSize: 1
                    value: MyService.AudioService.muted
                        ? 0
                        : MyService.AudioService.volumePercent

                    onMoved: {
                        MyService.AudioService.setVolumePercent(value)
                    }

                    background: Rectangle {
                        x: volumeSlider.leftPadding
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        implicitWidth: MyTheme.Sizes.sliderWidth
                        implicitHeight: 6
                        radius: 3
                        color: MyTheme.Colors.bgAlt

                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            radius: parent.radius
                            color: MyTheme.Colors.cyan
                        }
                    }

                    handle: Rectangle {
                        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
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
                            MyService.AudioService.setVolumePercent(
                                Math.min(100, volumeSlider.value + 5)
                            )
                        }
                    }
                }
            }
        }
    }
}
