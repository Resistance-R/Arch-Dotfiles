pragma Singleton
import QtQuick

QtObject {

    // Tokyonight Moon colors
    // Base
    property color bg: "#222436"
    property color bgAlt: "#1e2030"
    property color surface: "#2f334d"

    // transperent colors
    property color bgTransparent: Qt.rgba(0x22 / 255, 0x24 / 255, 0x36 / 255, 0.8)
    property color surfaceTransparent: Qt.rgba(0x2f / 255, 0x33 / 255, 0x4d / 255, 0.9)

    property color purpleTransparent: Qt.rgba(0xc0 / 255, 0x99 / 255, 0xff / 255, 0.3)
    property color blueTransparent: Qt.rgba(0x82 / 255, 0xaa / 255, 0xff / 255, 0.3)
    property color cyanTransparent: Qt.rgba(0x86 / 255, 0xe1 / 255, 0xfc / 255, 0.3)

    property color widgetSurface: Qt.rgba(0x2f / 255, 0x33 / 255, 0x4d / 255, 0.6)

    // Text
    property color text: "#c8d3f5"
    property color textDim: "#828bb8"

    // Accent
    property color blue: "#82aaff"
    property color purple: "#c099ff"
    property color cyan: "#86e1fc"

    // Status
    property color green: "#c3e88d"
    property color yellow: "#ffc777"
    property color red: "#ff757f"
}
