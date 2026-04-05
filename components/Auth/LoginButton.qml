import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property string text: "Unlock"
    property string colorText: "#d9e7ff"
    property string colorAccent: "#4ea0ff"
    property string secondaryAccent: "#5f9edb"
    property string fontFamily: "Noto Sans"
    property real controlDensity: 1.0
    property int cornerRadius: 10
    property string styleVariant: "balanced"
    property bool busy: false
    property bool enabled: true
    readonly property bool focused: mouseArea.pressed

    signal clicked()

    width: parent ? parent.width : 420
    height: Math.round(46 * root.controlDensity)
    radius: root.cornerRadius
    color: root.styleVariant === "pixel"
           ? (mouseArea.pressed ? Qt.darker(root.secondaryAccent, 1.35) : (mouseArea.containsMouse ? root.secondaryAccent : Qt.darker(root.secondaryAccent, 1.18)))
           : (mouseArea.pressed
              ? Qt.darker(root.colorAccent, 2.10)
              : (mouseArea.containsMouse ? Qt.darker(root.colorAccent, 1.85) : Qt.darker(root.colorAccent, 1.98)))
    opacity: root.enabled ? 1.0 : 0.72
    border.width: 1
    border.color: (mouseArea.containsMouse || focused)
                  ? Qt.darker(root.colorAccent, root.styleVariant === "pixel" ? 1.05 : 1.30)
                  : Qt.darker(root.colorAccent, root.styleVariant === "pixel" ? 1.20 : 1.45)

    Text {
        anchors.centerIn: parent
        visible: !root.busy
        text: root.text
        color: root.colorText
        font.pixelSize: Math.round((root.styleVariant === "pixel" ? 13 : 15) * root.controlDensity)
        font.bold: root.styleVariant !== "soft"
        font.family: root.fontFamily
        font.letterSpacing: root.styleVariant === "pixel" ? 1.0 : 0.4
    }

    BusyIndicator {
        visible: root.busy
        running: root.busy
        width: Math.round(14 * root.controlDensity)
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 0
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled && !root.busy
        hoverEnabled: true
        onClicked: {
            if (root.enabled && !root.busy) {
                root.clicked()
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: 120
        }
    }
}
