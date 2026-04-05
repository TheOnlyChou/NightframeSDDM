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
            icon.color: "#ffffff"
            onClicked: root.requestSuspend()

            background: Rectangle {
                radius: Math.max(6, root.cornerRadius - 1)
                color: sleepButton.down
                       ? (root.styleVariant === "pixel" ? "#3f2f68" : "#344b68")
                       : (sleepButton.hovered ? (root.styleVariant === "pixel" ? "#35295a" : "#2a3f5a") : "transparent")
                border.width: 1
                border.color: (sleepButton.hovered || sleepButton.visualFocus)
                              ? (palette ? palette.accent : "#4ea0ff")
                              : (palette ? palette.borderSubtle : "#2a3f5f")
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
            icon.color: "#ffffff"
            onClicked: root.requestReboot()

            background: Rectangle {
                radius: Math.max(6, root.cornerRadius - 1)
                color: rebootButton.down
                       ? (root.styleVariant === "pixel" ? "#3f2f68" : "#344b68")
                       : (rebootButton.hovered ? (root.styleVariant === "pixel" ? "#35295a" : "#2a3f5a") : "transparent")
                border.width: 1
                border.color: (rebootButton.hovered || rebootButton.visualFocus)
                              ? (palette ? palette.accent : "#4ea0ff")
                              : (palette ? palette.borderSubtle : "#2a3f5f")
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
            icon.color: "#ffffff"
            onClicked: root.requestShutdown()

            background: Rectangle {
                radius: Math.max(6, root.cornerRadius - 1)
                color: shutdownButton.down
                       ? (root.styleVariant === "pixel" ? "#5b2d69" : "#4b3a50")
                       : (shutdownButton.hovered ? (root.styleVariant === "pixel" ? "#4e295a" : "#3e3243") : "transparent")
                border.width: 1
                border.color: (shutdownButton.hovered || shutdownButton.visualFocus)
                              ? (palette ? palette.accent : "#4ea0ff")
                              : (palette ? palette.borderSubtle : "#2a3f5f")
            }
        }
    }
}
