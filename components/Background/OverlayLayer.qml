import QtQuick 2.15

Item {
    id: root
    property real overlayOpacity: 0.46

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: root.overlayOpacity
    }
}
