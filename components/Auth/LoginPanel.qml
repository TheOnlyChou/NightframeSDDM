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
    property real panelOpacity: 0.24
    property int panelRadius: 14
    property real controlDensity: 1.0
    property real titleOpacity: 0.98
    property real subtitleOpacity: 0.86
    property int controlSpacing: 10
    property real panelBorderStrength: 1.0
    property string styleVariant: "balanced"

    signal loginRequested(string userName, string password)

    height: panelColumn.implicitHeight

    readonly property bool hasMessage: messageText && messageText.trim().length > 0

    function clearPassword() {
        passwordInput.text = ""
        passwordInput.forceActiveFocus()
    }

    Rectangle {
        anchors.fill: panelColumn
        anchors.margins: -Math.round(20 * root.controlDensity)
        radius: root.panelRadius
        color: palette ? palette.panelGlass : "#3c101a29"
        opacity: root.panelOpacity
        border.width: Math.max(1, Math.round(root.panelBorderStrength))
        border.color: palette ? palette.borderSubtle : "#2a3f5f"
    }

    Column {
        id: panelColumn
        width: root.width
        spacing: Math.round(root.controlSpacing)

        Text {
            text: root.titleText
            color: palette ? palette.textPrimary : "#d9e7ff"
            opacity: root.titleOpacity
            font.pixelSize: Math.round(28 * root.controlDensity)
            font.family: root.fontFamily
            font.letterSpacing: root.styleVariant === "pixel" ? 1.5 : 1.0
        }

        Text {
            text: root.subtitleText
            color: palette ? palette.textMuted : "#8ea5c7"
            opacity: root.subtitleOpacity
            font.pixelSize: Math.round(13 * root.controlDensity)
            font.family: root.fontFamily
        }

        Item { width: 1; height: 2 }

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
            controlDensity: root.controlDensity
            cornerRadius: Math.max(4, root.panelRadius - 6)
            styleVariant: root.styleVariant
            panelBorderStrength: root.panelBorderStrength
            onAccepted: root.loginRequested(userDisplay.selectedUser, text)
        }

        Item { width: 1; height: 2 }

        Auth.LoginButton {
            width: parent.width
            text: "Login"
            colorText: palette ? palette.textPrimary : "#d9e7ff"
            colorAccent: palette ? palette.accent : "#4ea0ff"
            fontFamily: root.fontFamily
            controlDensity: root.controlDensity
            cornerRadius: Math.max(4, root.panelRadius - 4)
            styleVariant: root.styleVariant
            secondaryAccent: palette ? palette.accentSecondary : "#5f9edb"
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
