import QtQuick 2.15

import "../Auth" as Auth
import "../Widgets" as Widgets

Item {
    id: root

    property var userModelRef: null
    property var palette: null
    property string fontFamily: "Noto Sans"
    property string messageText: ""
    property string messageType: "info"
    property string titleText: "Welcome"
    property string subtitleText: "Sign in to start session"

    signal loginRequested(string userName, string password)

    height: panelColumn.implicitHeight

    readonly property bool hasMessage: messageText && messageText.trim().length > 0

    function clearPassword() {
        passwordInput.text = ""
        passwordInput.forceActiveFocus()
    }

    Rectangle {
        anchors.fill: panelColumn
        anchors.margins: -18
        radius: 14
        color: "#44101a29"
        border.width: 1
        border.color: palette ? palette.borderSubtle : "#2a3f5f"
    }

    Column {
        id: panelColumn
        width: root.width
        spacing: 12

        Text {
            text: root.titleText
            color: palette ? palette.textPrimary : "#d9e7ff"
            font.pixelSize: 30
            font.family: root.fontFamily
            font.letterSpacing: 1.0
        }

        Text {
            text: root.subtitleText
            color: palette ? palette.textMuted : "#8ea5c7"
            font.pixelSize: 14
            font.family: root.fontFamily
        }

        Auth.UserDisplay {
            id: userDisplay
            width: parent.width
            userModelRef: root.userModelRef
            colorText: palette ? palette.textPrimary : "#d9e7ff"
            colorMuted: palette ? palette.textMuted : "#8ea5c7"
            colorBorder: palette ? palette.borderSubtle : "#2a3f5f"
            fontFamily: root.fontFamily
        }

        Auth.PasswordInput {
            id: passwordInput
            width: parent.width
            placeholderText: "Password"
            colorText: palette ? palette.textPrimary : "#d9e7ff"
            colorAccent: palette ? palette.accent : "#4ea0ff"
            colorBorder: palette ? palette.borderSubtle : "#2a3f5f"
            fontFamily: root.fontFamily
            onAccepted: root.loginRequested(userDisplay.selectedUser, text)
        }

        Auth.LoginButton {
            width: parent.width
            text: "Login"
            colorText: palette ? palette.textPrimary : "#d9e7ff"
            colorAccent: palette ? palette.accent : "#4ea0ff"
            fontFamily: root.fontFamily
            onClicked: root.loginRequested(userDisplay.selectedUser, passwordInput.text)
        }

        Loader {
            active: root.hasMessage
            sourceComponent: Widgets.MessageBanner {
                width: panelColumn.width
                message: root.messageText
                type: root.messageType
                fontFamily: root.fontFamily
            }
        }
    }

    Component.onCompleted: passwordInput.forceActiveFocus()
}
