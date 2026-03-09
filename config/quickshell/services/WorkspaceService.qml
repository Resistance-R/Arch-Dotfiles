pragma Singleton
import QtQuick
import Quickshell.Hyprland

QtObject {
    readonly property int curWorkspace: Hyprland.focusedWorkspace.id
    readonly property int maxWs: 10

    readonly property var focusedWs: Hyprland.focusedWorkspace
    readonly property var activeTl: Hyprland.activeToplevel

    readonly property string activeTitle: {
        if (!focusedWs || !activeTl || !activeTl.workspace)
            return "Null"

        if (activeTl.workspace.id !== focusedWs.id)
            return "Null"

        if (activeTl.title && activeTl.title.length > 20)
            return "%1 ...".arg(activeTl.title.slice(0, 19))

        return activeTl.title && activeTl.title.length > 0
            ? activeTl.title
            : "Null"
    }
}
