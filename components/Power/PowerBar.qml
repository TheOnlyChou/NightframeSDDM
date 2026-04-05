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

    property url sleepIconSource: Qt.resolvedUrl("../../assets/svg/sleep.svg")
    property url rebootIconSource: Qt.resolvedUrl("../../assets/svg/reboot.svg")
    property url shutdownIconSource: Qt.resolvedUrl("../../assets/svg/shutdown.svg")

    width: 156
    height: 40

    Rectangle {
        visible: root.showBackground
        anchors.fill: parent
        radius: root.cornerRadius
        color: "#44212f46"
        border.width: 1
        border.color: palette ? palette.borderSubtle : "#2a3f5f"
    }

    Row {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        ToolButton {
            id: sleepButton
            width: 44
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
                color: sleepButton.down ? "#344b68" : (sleepButton.hovered ? "#2a3f5a" : "transparent")
                border.width: 1
                border.color: (sleepButton.hovered || sleepButton.visualFocus)
                              ? (palette ? palette.accent : "#4ea0ff")
                              : (palette ? palette.borderSubtle : "#2a3f5f")
            }
        }

        ToolButton {
            id: rebootButton
            width: 44
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
                color: rebootButton.down ? "#344b68" : (rebootButton.hovered ? "#2a3f5a" : "transparent")
                border.width: 1
                border.color: (rebootButton.hovered || rebootButton.visualFocus)
                              ? (palette ? palette.accent : "#4ea0ff")
                              : (palette ? palette.borderSubtle : "#2a3f5f")
            }
        }

        ToolButton {
            id: shutdownButton
            width: 44
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
                color: shutdownButton.down ? "#4b3a50" : (shutdownButton.hovered ? "#3e3243" : "transparent")
                border.width: 1
                border.color: (shutdownButton.hovered || shutdownButton.visualFocus)
                              ? (palette ? palette.accent : "#4ea0ff")
                              : (palette ? palette.borderSubtle : "#2a3f5f")
            }
        }
    }
}
