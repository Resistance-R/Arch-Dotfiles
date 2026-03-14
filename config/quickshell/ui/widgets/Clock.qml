import QtQuick
import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    signal clicked

    required property var panel
    required property var formatChange

    property bool changeFormat: formatChange

    implicitWidth: clockText.implicitWidth
    implicitHeight: clockText.implicitHeight

    Text {
        id: clockText

        anchors.centerIn: parent
        font.pixelSize: MyTheme.Sizes.fontSize
        color: MyTheme.Colors.text
        text: root.changeFormat
        ? Qt.formatDateTime(MyService.TimeService.now, "yyyy/MM/dd - HH:mm:ss")
        : Qt.formatTime(MyService.TimeService.now, "HH:mm")
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
