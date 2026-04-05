import QtQuick 2.15

Text {
    id: root

    property bool use24h: true
    property string fontFamily: "JetBrains Mono"
    property color textColor: "#d9e7ff"
    property real scaleFactor: 1.0
    property string styleVariant: "balanced"

    text: Qt.formatTime(new Date(), use24h ? "HH:mm" : "hh:mm AP")
    color: root.textColor
    font.family: root.fontFamily
    font.pixelSize: Math.round(Math.max(44, Screen.height * 0.062) * root.scaleFactor)
    font.letterSpacing: root.styleVariant === "pixel" ? 0.6 : (root.styleVariant === "minimal" ? 1.2 : 1.6)

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
