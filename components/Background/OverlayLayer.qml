import QtQuick 2.15

Item {
    id: root
    property real overlayOpacity: 0.46
    property color overlayColor: "#000000"

    readonly property real clampedOpacity: Math.max(0.0, Math.min(0.8, overlayOpacity))

    Rectangle {
        anchors.fill: parent
        color: root.overlayColor
        opacity: root.clampedOpacity
    }
}
