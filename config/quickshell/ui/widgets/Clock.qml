import QtQuick
import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    signal clicked

    required property var formatChange

    property bool changeFormat: formatChange

    implicitWidth: wrapper.implicitWidth
    implicitHeight: wrapper.implicitHeight

    Rectangle {
        id: wrapper

        anchors.centerIn: parent
        implicitHeight: MyTheme.Sizes.topbarElementHeight
        implicitWidth: clockText.implicitWidth + 16

        radius: MyTheme.Sizes.radius
        color: MyTheme.Colors.widgetSurface

        border.width: 1
        border.color: MyTheme.Colors.blueTransparent

        Text {
            id: clockText

            anchors.centerIn: parent
            font.pixelSize: MyTheme.Sizes.fontSize
            font.bold: root.changeFormat ? false : true
            color: MyTheme.Colors.text
            text: root.changeFormat
            ? Qt.formatDateTime(MyService.TimeService.now, "yyyy/MM/dd - HH:mm:ss")
            : Qt.formatTime(MyService.TimeService.now, "HH:mm")
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
            MyService.TimeService.reflashCalendar()
        }
    }
}
