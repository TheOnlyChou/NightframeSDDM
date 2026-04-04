import QtQuick 2.15

Item {
    id: root
    property var userModelRef: null
    property int currentIndex: 0
    property string selectedUser: ""
    property string colorText: "#d9e7ff"
    property string colorMuted: "#8ea5c7"
    property string colorBorder: "#2a3f5f"
    property string fontFamily: "Noto Sans"
    property string demoUserName: "theonlychou"

    signal userChanged(string userName)

    height: 58
    width: parent ? parent.width : 420

    function modelCount() {
        return userModelRef && userModelRef.count ? userModelRef.count : 0
    }

    function userNameAt(index) {
        if (!userModelRef || typeof userModelRef.get !== "function" || index < 0 || index >= modelCount()) {
            return demoUserName
        }
        var u = userModelRef.get(index)
        return u && u.name ? u.name : demoUserName
    }

    function updateSelected() {
        if (modelCount() > 0) {
            selectedUser = userNameAt(currentIndex)
        }
    }

    onCurrentIndexChanged: {
        updateSelected()
        userChanged(selectedUser)
    }

    Component.onCompleted: {
        if (modelCount() > 0) {
            currentIndex = Math.max(0, Math.min(currentIndex, modelCount() - 1))
            updateSelected()
            userChanged(selectedUser)
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: "#2a0f1a29"
        border.color: root.colorBorder
        border.width: 1
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 8

        Text {
            visible: root.modelCount() > 1
            text: "<"
            color: root.colorMuted
            font.pixelSize: 18
            font.family: root.fontFamily
            verticalAlignment: Text.AlignVCenter
            height: parent.height

            MouseArea {
                anchors.fill: parent
                enabled: root.modelCount() > 1
                onClicked: root.currentIndex = (root.currentIndex - 1 + root.modelCount()) % root.modelCount()
            }
        }

        Text {
            id: userNameText
            text: root.modelCount() > 0 ? root.selectedUser : root.demoUserName
            color: root.colorText
            font.pixelSize: 18
            font.family: root.fontFamily
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            width: parent.width - 64
        }

        Text {
            visible: root.modelCount() > 1
            text: ">"
            color: root.colorMuted
            font.pixelSize: 18
            font.family: root.fontFamily
            verticalAlignment: Text.AlignVCenter
            height: parent.height

            MouseArea {
                anchors.fill: parent
                enabled: root.modelCount() > 1
                onClicked: root.currentIndex = (root.currentIndex + 1) % root.modelCount()
            }
        }
    }
}
