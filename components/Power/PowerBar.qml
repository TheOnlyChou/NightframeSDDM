import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property var palette: null
    property string fontFamily: "Noto Sans"

    signal requestSuspend()
    signal requestReboot()
    signal requestShutdown()

    property url sleepIconSource: Qt.resolvedUrl("../../assets/svg/sleep.svg")
    property url rebootIconSource: Qt.resolvedUrl("../../assets/svg/reboot.svg")
    property url shutdownIconSource: Qt.resolvedUrl("../../assets/svg/shutdown.svg")

    width: 156
    height: 44

    Rectangle {
        anchors.fill: parent
        radius: 10
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
            height: 36
            hoverEnabled: true
            display: AbstractButton.IconOnly
            icon.source: root.sleepIconSource
            icon.width: 18
            icon.height: 18
            icon.color: "#ffffff"
            onClicked: root.requestSuspend()

            background: Rectangle {
                radius: 8
                color: sleepButton.down ? "#3a4c67" : (sleepButton.hovered ? "#2f4058" : "transparent")
                border.width: 1
                border.color: sleepButton.hovered ? (palette ? palette.accent : "#4ea0ff") : (palette ? palette.borderSubtle : "#2a3f5f")
            }
        }

        ToolButton {
            id: rebootButton
            width: 44
            height: 36
            hoverEnabled: true
            display: AbstractButton.IconOnly
            icon.source: root.rebootIconSource
            icon.width: 18
            icon.height: 18
            icon.color: "#ffffff"
            onClicked: root.requestReboot()

            background: Rectangle {
                radius: 8
                color: rebootButton.down ? "#3a4c67" : (rebootButton.hovered ? "#2f4058" : "transparent")
                border.width: 1
                border.color: rebootButton.hovered ? (palette ? palette.accent : "#4ea0ff") : (palette ? palette.borderSubtle : "#2a3f5f")
            }
        }

        ToolButton {
            id: shutdownButton
            width: 44
            height: 36
            hoverEnabled: true
            display: AbstractButton.IconOnly
            icon.source: root.shutdownIconSource
            icon.width: 18
            icon.height: 18
            icon.color: "#ffffff"
            onClicked: root.requestShutdown()

            background: Rectangle {
                radius: 8
                color: shutdownButton.down ? "#4f3b50" : (shutdownButton.hovered ? "#3f3241" : "transparent")
                border.width: 1
                border.color: shutdownButton.hovered ? (palette ? palette.accent : "#4ea0ff") : (palette ? palette.borderSubtle : "#2a3f5f")
            }
        }
    }
}
