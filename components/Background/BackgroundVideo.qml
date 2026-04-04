import QtQuick 2.15
import QtMultimedia 6.5

Item {
    id: root
    property url source: ""
    property url fallbackSource: ""
    property bool playing: true
    readonly property bool playbackError: mediaPlayer.error !== MediaPlayer.NoError

    signal playbackFailed()

    function notifyPlaybackFailure() {
        if (root.playbackError) {
            root.playbackFailed()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#020812"
    }

    MediaPlayer {
        id: mediaPlayer
        source: root.source
        loops: MediaPlayer.Infinite
        autoPlay: root.playing && !!root.source
        videoOutput: videoOutput
        audioOutput: AudioOutput {
            muted: true
            volume: 0.0
        }

        onErrorOccurred: root.notifyPlaybackFailure()
        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.InvalidMedia) {
                root.notifyPlaybackFailure()
            }
        }
    }

    Image {
        id: fallbackImage
        anchors.fill: parent
        source: root.fallbackSource
        visible: !root.source || root.playbackError
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        smooth: true
        mipmap: true
    }

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        visible: !root.playbackError
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        visible: (!root.source || root.playbackError) && fallbackImage.status === Image.Error
        color: "#020812"
    }
}
