import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property var sessionModelRef: null
    property var palette: null
    property string fontFamily: "Noto Sans"
    property int currentIndex: 0
    property string demoSessionName: "Hyprland"
    property var demoSessionList: ["Hyprland", "GNOME", "Plasma"]
    property bool showBackground: true
    property int cornerRadius: 8
    property real controlDensity: 1.0
    property string styleVariant: "balanced"
    property real panelBorderStrength: 1.0

    readonly property bool hovered: hoverArea.containsMouse
    readonly property bool menuOpen: sessionPopup.visible

    width: Math.round((styleVariant === "pixel" ? 236 : 250) * controlDensity)
    height: Math.round(40 * controlDensity)

    function modelCount() {
        return sessionModelRef && sessionModelRef.count ? sessionModelRef.count : 0
    }

    function modelSessionNameAt(index) {
        if (!sessionModelRef || typeof sessionModelRef.get !== "function" || index < 0 || index >= modelCount()) {
            return ""
        }
        var s = sessionModelRef.get(index)
        return s && s.name ? s.name.toString() : ""
    }

    function modelHasUsableNames() {
        if (!sessionModelRef || typeof sessionModelRef.get !== "function" || modelCount() <= 0) {
            return false
        }
        for (var i = 0; i < modelCount(); i++) {
            if (modelSessionNameAt(i).trim().length > 0) {
                return true
            }
        }
        return false
    }

    function effectiveDemoList() {
        if (demoSessionList && demoSessionList.length > 0) {
            return demoSessionList
        }
        return [demoSessionName]
    }

    function sessionCount() {
        if (modelHasUsableNames()) {
            return modelCount()
        }
        return effectiveDemoList().length
    }

    function sessionNameAt(index) {
        if (index < 0 || index >= sessionCount()) {
            return demoSessionName
        }
        if (modelHasUsableNames()) {
            var modelName = modelSessionNameAt(index)
            if (modelName.trim().length > 0) {
                return modelName
            }
        }
        var demoList = effectiveDemoList()
        return demoList[index] || demoSessionName
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
        border.color: (hovered || root.menuOpen)
                      ? (palette ? palette.accent : "#4ea0ff")
                      : (palette ? palette.borderSubtle : "#2a3f5f")

        Behavior on border.color {
            ColorAnimation { duration: 120 }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.cornerRadius
        color: hovered || root.menuOpen ? (root.styleVariant === "pixel" ? "#27235a66" : "#1f2a3a52") : "transparent"
        opacity: hovered || root.menuOpen ? 0.28 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: 120 }
        }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: Math.round(10 * root.controlDensity)
        anchors.rightMargin: Math.round(10 * root.controlDensity)
        spacing: Math.round(7 * root.controlDensity)

        Text {
            width: parent.width - 25
            height: parent.height
            text: root.sessionNameAt(root.currentIndex)
            color: palette ? palette.textPrimary : "#d9e7ff"
            font.family: root.fontFamily
            font.pixelSize: Math.round(14 * root.controlDensity)
            font.bold: root.styleVariant !== "soft"
            opacity: 0.98
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            width: 18
            height: parent.height
            text: root.menuOpen ? "▴" : "▾"
            color: palette ? palette.textMuted : "#8ea5c7"
            font.family: root.fontFamily
            font.pixelSize: Math.round(12 * root.controlDensity)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        onClicked: {
            if (root.sessionCount() > 1) {
                if (sessionPopup.visible) {
                    sessionPopup.close()
                } else {
                    sessionPopup.open()
                }
            }
        }
    }

    Popup {
        id: sessionPopup
        x: root.x
        y: root.y - height + 2
        width: root.width
        height: Math.min(Math.max(1, root.sessionCount()) * Math.round(34 * root.controlDensity) + 10, Math.round(190 * root.controlDensity))
        modal: false
        focus: true
        padding: 4
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: Math.max(6, root.cornerRadius)
            color: palette ? palette.panelGlassStrong : "#5a1a2537"
            border.width: Math.max(1, Math.round(root.panelBorderStrength))
            border.color: palette ? palette.borderSubtle : "#2a3f5f"
        }

        ListView {
            id: sessionListView
            anchors.fill: parent
            clip: true
            model: root.sessionCount()
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: root.currentIndex

            delegate: Rectangle {
                width: sessionListView.width
                height: Math.round(34 * root.controlDensity)
                radius: Math.max(4, root.cornerRadius - 3)
                color: {
                    if (index === root.currentIndex) {
                        return root.styleVariant === "pixel" ? "#3c2a6f" : "#2f4462"
                    }
                    return delegateArea.containsMouse ? (root.styleVariant === "pixel" ? "#2c2352" : "#22344a") : "transparent"
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Math.round(10 * root.controlDensity)
                    anchors.right: parent.right
                    anchors.rightMargin: Math.round(10 * root.controlDensity)
                    text: root.sessionNameAt(index)
                    color: palette ? palette.textPrimary : "#d9e7ff"
                    font.family: root.fontFamily
                    font.pixelSize: Math.round(13 * root.controlDensity)
                    elide: Text.ElideRight
                }

                MouseArea {
                    id: delegateArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        root.currentIndex = index
                        sessionPopup.close()
                    }
                }
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }
}
