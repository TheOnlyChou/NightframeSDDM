import QtQuick 2.15

Rectangle {
    id: root
    property string message: ""
    property string type: "info"
    property string fontFamily: "Noto Sans"
    readonly property bool hasMessage: message && message.trim().length > 0

    visible: hasMessage
    radius: 8
    height: hasMessage ? 34 : 0
    width: parent ? parent.width : 420
    color: {
        if (type === "error") return "#30ff6b86"
        if (type === "ok") return "#2a7bd7b4"
        return "#26344b63"
    }
    border.width: 1
    border.color: {
        if (type === "error") return "#ff6b86"
        if (type === "ok") return "#7bd7b4"
        return "#5f84b1"
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
        text: root.message
        color: "#d9e7ff"
        font.pixelSize: 13
        font.family: root.fontFamily
        elide: Text.ElideRight
    }

    Behavior on height {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutQuad
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 140
            easing.type: Easing.OutQuad
        }
    }
}
