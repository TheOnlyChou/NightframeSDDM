import QtQuick 2.15

Item {
    id: root
    visible: false
    width: 0
    height: 0

    property string uiFontPath: ""
    property string clockFontPath: ""
    property string pixelFontPath: ""

    readonly property string fallbackUiFamily: "Sans Serif"
    readonly property string fallbackClockFamily: "Monospace"
    readonly property string uiFamily: uiLoader.status === FontLoader.Ready ? uiLoader.name : fallbackUiFamily
    readonly property string clockFamily: clockLoader.status === FontLoader.Ready
                                        ? clockLoader.name
                                        : (pixelLoader.status === FontLoader.Ready ? pixelLoader.name : fallbackClockFamily)

    FontLoader {
        id: uiLoader
        source: root.uiFontPath
    }

    FontLoader {
        id: clockLoader
        source: root.clockFontPath
    }

    FontLoader {
        id: pixelLoader
        source: root.pixelFontPath
    }
}
