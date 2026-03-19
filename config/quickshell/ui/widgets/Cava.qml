import QtQuick

import "../../theme" as MyTheme
import "../../services" as MyService

Item {
    id: root

    signal clicked

    required property var values
    required property real barWidth
    required property bool active

    implicitWidth: barWidth / 4
    implicitHeight: MyTheme.Sizes.widgetHeight

    Row {
        id: barRow
        anchors.fill: parent
        spacing: 2

        Repeater {
            model: root.values.length

            delegate: Item {
                required property int index

                width: (barRow.width - (root.values.length - 1) * barRow.spacing)
                       / Math.max(1, root.values.length)
                height: barRow.height

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    height: root.active
                        ? Math.max(2, (root.values[index] / 100.0) * parent.height)
                        : 2

                    radius: 1
                    color: MyTheme.Colors.purple
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            MyService.CavaService.toggle()
        }
    }
}
