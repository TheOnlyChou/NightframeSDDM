import QtQuick 2.15

Item {
    id: root
    visible: false
    width: 0
    height: 0

    property string pixelFontPath: ""
    readonly property string uiFamily: "Sans Serif"
    readonly property string fallbackClockFamily: "Monospace"
    readonly property string clockFamily: pixelLoader.status === FontLoader.Ready ? pixelLoader.name : fallbackClockFamily

    FontLoader {
        id: pixelLoader
        source: root.pixelFontPath
    }
}
