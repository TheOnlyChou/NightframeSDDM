import QtQuick 2.15

Item {
    id: root
    property alias text: passwordField.text
    property string placeholderText: "Password"
    property string colorText: "#d9e7ff"
    property string colorAccent: "#4ea0ff"
    property string colorBorder: "#2a3f5f"
    property string fontFamily: "Noto Sans"

    signal accepted()

    readonly property bool hovered: hoverTracker.containsMouse

    width: parent ? parent.width : 420
    height: 54

    Rectangle {
        anchors.fill: parent
        color: hovered ? "#24111d2b" : "#20101926"
        radius: 8
        border.width: 1
        border.color: passwordField.activeFocus ? Qt.lighter(root.colorAccent, 1.15)
                                               : (hovered ? Qt.lighter(root.colorBorder, 1.15) : root.colorBorder)
    }

    Rectangle {
        width: parent.width
        height: 2
        color: root.colorAccent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        opacity: passwordField.activeFocus ? 0.95 : 0.5
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: "transparent"
        border.width: 1
        border.color: root.colorAccent
        opacity: passwordField.activeFocus ? 0.26 : 0.0
    }

    TextInput {
        id: passwordField
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        color: root.colorText
        font.pixelSize: 17
        font.family: root.fontFamily
        echoMode: TextInput.Password
        verticalAlignment: TextInput.AlignVCenter
        selectByMouse: true
        clip: true

        onAccepted: root.accepted()
    }

    MouseArea {
        id: hoverTracker
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
    }

    Text {
        visible: passwordField.length === 0 && !passwordField.activeFocus
        text: root.placeholderText
        color: "#7690b6"
        font.pixelSize: 15
        font.family: root.fontFamily
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 14
    }
}
