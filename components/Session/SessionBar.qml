import QtQuick 2.15

Item {
    id: root

    property var sessionModelRef: null
    property var palette: null
    property string fontFamily: "Noto Sans"
    property int currentIndex: 0
    property string demoSessionName: "Hyprland"
    property bool showBackground: true
    property int cornerRadius: 8
    property real controlDensity: 1.0
    property string styleVariant: "balanced"
    property real panelBorderStrength: 1.0

    readonly property bool hovered: hoverArea.containsMouse

    width: Math.round((styleVariant === "pixel" ? 240 : 260) * controlDensity)
    height: Math.round(40 * controlDensity)

    function sessionCount() {
        return sessionModelRef && sessionModelRef.count ? sessionModelRef.count : 0
    }

    function sessionNameAt(index) {
        if (!sessionModelRef || typeof sessionModelRef.get !== "function" || index < 0 || index >= sessionCount()) {
            return demoSessionName
        }
        var s = sessionModelRef.get(index)
        return s && s.name ? s.name : demoSessionName
    }

    Component.onCompleted: {
        if (sessionCount() > 0) {
            currentIndex = Math.max(0, Math.min(currentIndex, sessionCount() - 1))
        }
    }

    Rectangle {
        visible: root.showBackground
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.styleVariant === "soft" ? "#4d2b3948" : "#44212f46"
        border.width: Math.max(1, Math.round(root.panelBorderStrength))
        border.color: palette ? palette.borderSubtle : "#2a3f5f"
    }

    Rectangle {
        anchors.fill: parent
        radius: root.cornerRadius
        color: hovered ? "#1f2a3a52" : "transparent"
        border.width: 1
        border.color: hovered ? (palette ? palette.accent : "#4ea0ff") : "transparent"
        opacity: hovered ? 0.26 : 0.0
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: Math.max(4, Math.round(6 * root.controlDensity))

        Rectangle {
            width: 24
            height: parent.height
            radius: Math.max(4, root.cornerRadius - 2)
            color: leftArea.containsMouse ? (root.styleVariant === "pixel" ? "#3a2b63" : "#2c3f58") : "transparent"

            Text {
                anchors.centerIn: parent
                text: "<"
                color: leftArea.containsMouse ? (palette ? palette.textPrimary : "#d9e7ff") : (palette ? palette.textMuted : "#8ea5c7")
                font.family: root.fontFamily
                font.pixelSize: Math.round(14 * root.controlDensity)
                font.bold: true
            }

            MouseArea {
                id: leftArea
                anchors.fill: parent
                enabled: root.sessionCount() > 1
                hoverEnabled: true
                onClicked: root.currentIndex = (root.currentIndex - 1 + root.sessionCount()) % root.sessionCount()
            }
        }

        Text {
            width: parent.width - 60
            text: root.sessionNameAt(root.currentIndex)
            color: palette ? palette.textPrimary : "#d9e7ff"
            font.family: root.fontFamily
            font.pixelSize: Math.round(14 * root.controlDensity)
            opacity: 0.96
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            height: parent.height
        }

        Rectangle {
            width: 24
            height: parent.height
            radius: Math.max(4, root.cornerRadius - 2)
            color: rightArea.containsMouse ? (root.styleVariant === "pixel" ? "#3a2b63" : "#2c3f58") : "transparent"

            Text {
                anchors.centerIn: parent
                text: ">"
                color: rightArea.containsMouse ? (palette ? palette.textPrimary : "#d9e7ff") : (palette ? palette.textMuted : "#8ea5c7")
                font.family: root.fontFamily
                font.pixelSize: Math.round(14 * root.controlDensity)
                font.bold: true
            }

            MouseArea {
                id: rightArea
                anchors.fill: parent
                enabled: root.sessionCount() > 1
                hoverEnabled: true
                onClicked: root.currentIndex = (root.currentIndex + 1) % root.sessionCount()
            }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }
}
