import QtQuick 2.15

Item {
    id: root
    property url source: ""
    property url fallbackSource: "assets/backgrounds/default.jpg"

    readonly property url resolvedSource: source && source.toString().length > 0 ? source : fallbackSource
    readonly property bool primaryFailed: bgImage.status === Image.Error

    Rectangle {
        anchors.fill: parent
        color: "#020812"
    }

    Image {
        id: bgImage
        anchors.fill: parent
        source: root.resolvedSource
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        smooth: true
        mipmap: true
    }

    Image {
        id: fallbackImage
        anchors.fill: parent
        source: root.fallbackSource
        visible: root.primaryFailed && !!root.fallbackSource
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        smooth: true
        mipmap: true
    }

    Rectangle {
        anchors.fill: parent
        visible: root.primaryFailed && fallbackImage.status === Image.Error
        color: "#020812"
    }
}
