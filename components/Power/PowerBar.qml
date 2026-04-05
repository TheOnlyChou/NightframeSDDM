import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property var palette: null
    property string fontFamily: "Noto Sans"

    signal requestSuspend()
    signal requestReboot()
    signal requestShutdown()
    property bool showBackground: true
    property int cornerRadius: 8
    property real controlDensity: 1.0
    property string styleVariant: "balanced"
    property real panelBorderStrength: 1.0

    property url sleepIconSource: Qt.resolvedUrl("../../assets/svg/sleep.svg")
    property url rebootIconSource: Qt.resolvedUrl("../../assets/svg/reboot.svg")
    property url shutdownIconSource: Qt.resolvedUrl("../../assets/svg/shutdown.svg")

    width: Math.round((styleVariant === "pixel" ? 148 : 156) * controlDensity)
    height: Math.round(40 * controlDensity)

    function buttonBackgroundColor(button, baseColor, hoverColor, pressedColor) {
        if (button.down) {
            return pressedColor
        }
        if (button.hovered || button.visualFocus) {
            return hoverColor
        }
        return baseColor
    }

    Rectangle {
        visible: root.showBackground
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.styleVariant === "soft" ? "#4d2b3948" : "#44212f46"
        border.width: Math.max(1, Math.round(root.panelBorderStrength))
        border.color: palette ? palette.borderSubtle : "#2a3f5f"
    }

    Row {
        anchors.fill: parent
        anchors.margins: 4
        spacing: Math.max(2, Math.round(4 * root.controlDensity))

        ToolButton {
            id: sleepButton
            width: Math.round((root.styleVariant === "pixel" ? 40 : 44) * root.controlDensity)
            height: parent.height
            hoverEnabled: true
            focusPolicy: Qt.StrongFocus
            display: AbstractButton.IconOnly
            icon.source: root.sleepIconSource
            icon.width: 17
            icon.height: 17
            icon.color: sleepButton.down ? "#f1f6ff" : (sleepButton.hovered ? "#ffffff" : "#d6e3f5")
            onClicked: root.requestSuspend()

            background: Rectangle {
                radius: Math.max(6, root.cornerRadius - 1)
                color: root.buttonBackgroundColor(
                           sleepButton,
                           "transparent",
                           palette ? palette.controlHover : (root.styleVariant === "pixel" ? "#35295a" : "#2a3f5a"),
                           palette ? palette.controlPressed : (root.styleVariant === "pixel" ? "#3f2f68" : "#344b68")
                       )
                border.width: 1
                border.color: (sleepButton.hovered || sleepButton.visualFocus)
                              ? (palette ? palette.accent : "#4ea0ff")
                              : (palette ? palette.borderSubtle : "#2a3f5f")

                Behavior on color {
                    ColorAnimation { duration: 110 }
                }

                Behavior on border.color {
                    ColorAnimation { duration: 110 }
                }
            }
        }

        ToolButton {
            id: rebootButton
            width: Math.round((root.styleVariant === "pixel" ? 40 : 44) * root.controlDensity)
            height: parent.height
            hoverEnabled: true
            focusPolicy: Qt.StrongFocus
            display: AbstractButton.IconOnly
            icon.source: root.rebootIconSource
            icon.width: 17
            icon.height: 17
            icon.color: rebootButton.down ? "#f1f6ff" : (rebootButton.hovered ? "#ffffff" : "#d6e3f5")
            onClicked: root.requestReboot()

            background: Rectangle {
                radius: Math.max(6, root.cornerRadius - 1)
                color: root.buttonBackgroundColor(
                           rebootButton,
                           "transparent",
                           palette ? palette.controlHover : (root.styleVariant === "pixel" ? "#35295a" : "#2a3f5a"),
                           palette ? palette.controlPressed : (root.styleVariant === "pixel" ? "#3f2f68" : "#344b68")
                       )
                border.width: 1
                border.color: (rebootButton.hovered || rebootButton.visualFocus)
                              ? (palette ? palette.accent : "#4ea0ff")
                              : (palette ? palette.borderSubtle : "#2a3f5f")

                Behavior on color {
                    ColorAnimation { duration: 110 }
                }

                Behavior on border.color {
                    ColorAnimation { duration: 110 }
                }
            }
        }

        ToolButton {
            id: shutdownButton
            width: Math.round((root.styleVariant === "pixel" ? 40 : 44) * root.controlDensity)
            height: parent.height
            hoverEnabled: true
            focusPolicy: Qt.StrongFocus
            display: AbstractButton.IconOnly
            icon.source: root.shutdownIconSource
            icon.width: 17
            icon.height: 17
            icon.color: shutdownButton.down ? "#ffeef3" : (shutdownButton.hovered ? "#fff6f8" : "#f2d9df")
            onClicked: root.requestShutdown()

            background: Rectangle {
                radius: Math.max(6, root.cornerRadius - 1)
                color: root.buttonBackgroundColor(
                           shutdownButton,
                           "transparent",
                           palette ? palette.controlDangerHover : (root.styleVariant === "pixel" ? "#4e295a" : "#3e3243"),
                           palette ? palette.controlDangerPressed : (root.styleVariant === "pixel" ? "#5b2d69" : "#4b3a50")
                       )
                border.width: 1
                border.color: (shutdownButton.hovered || shutdownButton.visualFocus)
                              ? (palette ? palette.danger : "#ff6b86")
                              : (palette ? palette.borderSubtle : "#2a3f5f")

                Behavior on color {
                    ColorAnimation { duration: 110 }
                }

                Behavior on border.color {
                    ColorAnimation { duration: 110 }
                }
            }
        }
    }
}
