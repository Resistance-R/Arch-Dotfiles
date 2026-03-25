import QtQuick

Item {
    id: root

    required property Item target
    required property bool visibleState

    property int duration: 200

    OpacityAnimator {
        id: fadeAnim
        target: root.target
        duration: root.duration
    }

    onVisibleStateChanged: {
        fadeAnim.from = visibleState ? 0 : 1
        fadeAnim.to   = visibleState ? 1 : 0
        fadeAnim.restart()
    }
}
