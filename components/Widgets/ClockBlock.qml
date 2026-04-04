import QtQuick 2.15

Text {
    id: root

    property bool use24h: true
    property string fontFamily: "JetBrains Mono"
    property color textColor: "#d9e7ff"

    text: Qt.formatTime(new Date(), use24h ? "HH:mm" : "hh:mm AP")
    color: root.textColor
    font.family: root.fontFamily
    font.pixelSize: Math.max(50, Screen.height * 0.062)
    font.letterSpacing: 1.6

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.text = Qt.formatTime(new Date(), root.use24h ? "HH:mm" : "hh:mm AP")
    }

    opacity: 0.0

    Behavior on opacity {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutCubic
        }
    }

    Component.onCompleted: opacity = 1.0
}
