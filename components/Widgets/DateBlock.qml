import QtQuick 2.15

Text {
    id: root

    property string fontFamily: "Noto Sans"
    property color textColor: "#8ea5c7"
    property real textOpacity: 0.78

    text: Qt.formatDate(new Date(), "ddd, dd MMM yyyy")
    color: root.textColor
    opacity: Math.max(0.55, Math.min(1.0, root.textOpacity))
    font.family: root.fontFamily
    font.pixelSize: 14
    font.letterSpacing: 0.8

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root.text = Qt.formatDate(new Date(), "ddd, dd MMM yyyy")
    }
}
