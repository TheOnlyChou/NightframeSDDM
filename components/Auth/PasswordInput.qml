import QtQuick 2.15

Item {
    id: root
    property alias text: passwordField.text
    property string placeholderText: "Password"
    property string colorText: "#d9e7ff"
    property string colorAccent: "#4ea0ff"
    property string colorBorder: "#2a3f5f"
    property string fontFamily: "Noto Sans"
    property real controlDensity: 1.0
    property int cornerRadius: 8
    property string styleVariant: "balanced"
    property real panelBorderStrength: 1.0

    signal accepted()

    readonly property bool hovered: hoverTracker.containsMouse

    width: parent ? parent.width : 420
    height: Math.round(54 * root.controlDensity)

    Rectangle {
        anchors.fill: parent
        color: root.styleVariant === "soft"
               ? (hovered ? "#2e1e2936" : "#261b2532")
               : (hovered ? "#24111d2b" : "#20101926")
        radius: root.cornerRadius
        border.width: Math.max(1, Math.round(root.panelBorderStrength))
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
        opacity: passwordField.activeFocus ? 0.95 : (root.styleVariant === "minimal" ? 0.35 : 0.5)
    }

    Rectangle {
        anchors.fill: parent
        radius: root.cornerRadius
        color: "transparent"
        border.width: 1
        border.color: root.colorAccent
        opacity: passwordField.activeFocus ? (root.styleVariant === "pixel" ? 0.38 : 0.26) : 0.0
    }

    TextInput {
        id: passwordField
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        color: root.colorText
        font.pixelSize: Math.round(17 * root.controlDensity)
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
        font.pixelSize: Math.round(15 * root.controlDensity)
        font.family: root.fontFamily
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 14
    }
}
