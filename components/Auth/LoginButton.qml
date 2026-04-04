import QtQuick 2.15

Rectangle {
    id: root
    property string text: "Unlock"
    property string colorText: "#d9e7ff"
    property string colorAccent: "#4ea0ff"
    property string fontFamily: "Noto Sans"

    signal clicked()

    width: parent ? parent.width : 420
    height: 46
    radius: 10
    color: mouseArea.containsMouse ? Qt.darker(colorAccent, 1.15) : colorAccent
    border.width: 1
    border.color: Qt.lighter(colorAccent, 1.2)

    Text {
        anchors.centerIn: parent
        text: root.text
        color: root.colorText
        font.pixelSize: 15
        font.bold: true
        font.family: root.fontFamily
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
