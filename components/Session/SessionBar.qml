import QtQuick 2.15

Item {
    id: root

    property var sessionModelRef: null
    property var palette: null
    property string fontFamily: "Noto Sans"
    property int currentIndex: 0
    property string demoSessionName: "Hyprland"

    width: 260
    height: 44

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
        anchors.fill: parent
        radius: 10
        color: "#44212f46"
        border.width: 1
        border.color: palette ? palette.borderSubtle : "#2a3f5f"
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 8

        Text {
            text: "<"
            color: palette ? palette.textMuted : "#8ea5c7"
            font.family: root.fontFamily
            font.pixelSize: 16
            verticalAlignment: Text.AlignVCenter
            height: parent.height

            MouseArea {
                anchors.fill: parent
                enabled: root.sessionCount() > 1
                onClicked: root.currentIndex = (root.currentIndex - 1 + root.sessionCount()) % root.sessionCount()
            }
        }

        Text {
            width: parent.width - 52
            text: root.sessionNameAt(root.currentIndex)
            color: palette ? palette.textPrimary : "#d9e7ff"
            font.family: root.fontFamily
            font.pixelSize: 14
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            height: parent.height
        }

        Text {
            text: ">"
            color: palette ? palette.textMuted : "#8ea5c7"
            font.family: root.fontFamily
            font.pixelSize: 16
            verticalAlignment: Text.AlignVCenter
            height: parent.height

            MouseArea {
                anchors.fill: parent
                enabled: root.sessionCount() > 1
                onClicked: root.currentIndex = (root.currentIndex + 1) % root.sessionCount()
            }
        }
    }
}
