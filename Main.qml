import QtQuick 2.15
import QtQuick.Controls 2.15

import "components/Background" as Background
import "components/Auth" as Auth
import "components/Widgets" as Widgets
import "components/Power" as Power
import "components/Session" as Session
import "components/Common" as Common

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#020812"

    Common.ThemeColors {
        id: palette
        accentOverride: config.AccentColor || ""
    }

    Common.ThemeMetrics {
        id: metrics
    }

    Common.ThemeFonts {
        id: themeFonts
        pixelFontPath: Qt.resolvedUrl(config.PixelFont || "")
    }

    property bool useVideoBackground: {
        var mode = (config.BackgroundMode || "image").toString().toLowerCase()
        var modeWantsVideo = mode === "video"
        if (typeof config.UseVideo === "boolean") {
            return config.UseVideo || modeWantsVideo
        }
        return (config.UseVideo || "false").toString().toLowerCase() === "true" || modeWantsVideo
    }

    property url backgroundImagePath: Qt.resolvedUrl(config.BackgroundImage || "assets/backgrounds/default.jpg")
    property url backgroundVideoPath: Qt.resolvedUrl(config.BackgroundVideo || "assets/video/nightframe.mp4")
    property real overlayStrength: Number(config.OverlayStrength || 0.46)
    property bool use24hClock: {
        if (typeof config.Clock24h === "boolean") {
            return config.Clock24h
        }
        return (config.Clock24h || "true").toString().toLowerCase() !== "false"
    }

    property string statusText: ""
    property string statusType: "info"
    property bool videoPlaybackFailed: false

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: (root.useVideoBackground && !root.videoPlaybackFailed) ? backgroundVideoComponent : backgroundImageComponent
    }

    Component {
        id: backgroundImageComponent
        Background.BackgroundImage {
            anchors.fill: parent
            source: root.backgroundImagePath
            fallbackSource: Qt.resolvedUrl("assets/backgrounds/default.jpg")
        }
    }

    Component {
        id: backgroundVideoComponent
        Background.BackgroundVideo {
            anchors.fill: parent
            source: root.backgroundVideoPath
            fallbackSource: root.backgroundImagePath
            playing: true
            onPlaybackFailed: {
                root.videoPlaybackFailed = true
                root.statusText = "Video unavailable, using image background"
                root.statusType = "info"
            }
        }
    }

    Background.OverlayLayer {
        anchors.fill: parent
        overlayOpacity: Math.max(0.12, Math.min(0.55, root.overlayStrength))
    }

    Column {
        id: topLeftInfo
        spacing: 8
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: metrics.edgeMargin
        anchors.topMargin: metrics.edgeMargin

        Widgets.ClockBlock {
            id: clockBlock
            use24h: root.use24hClock
            fontFamily: themeFonts.clockFamily
            textColor: palette.textPrimary
        }

        Widgets.DateBlock {
            textColor: palette.textMuted
            fontFamily: themeFonts.uiFamily
        }
    }

    Auth.LoginPanel {
        id: loginPanel
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: metrics.leftPanelMargin
        width: Math.min(metrics.loginPanelMaxWidth, parent.width * 0.34)

        userModelRef: typeof userModel !== "undefined" ? userModel : null
        messageText: root.statusText
        messageType: root.statusType
        palette: palette
        fontFamily: themeFonts.uiFamily

        onLoginRequested: function(userName, password) {
            root.statusText = "Authenticating..."
            root.statusType = "info"
            if (typeof sddm !== "undefined" && sddm) {
                sddm.login(userName, password, sessionBar.currentIndex)
            } else {
                root.statusText = "Test mode: login action"
                root.statusType = "info"
            }
        }
    }

    Rectangle {
        id: bottomRightControls
        height: metrics.floatingControlsHeight
        radius: metrics.floatingControlsRadius
        color: palette.panelGlassStrong
        border.width: 1
        border.color: palette.borderSubtle
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: metrics.edgeMargin
        anchors.bottomMargin: metrics.edgeMargin
        width: controlsRow.implicitWidth + metrics.floatingControlsPadding * 2

        Row {
            id: controlsRow
            anchors.fill: parent
            anchors.margins: metrics.floatingControlsPadding
            spacing: 10

            Session.SessionBar {
                id: sessionBar
                height: parent.height
                sessionModelRef: typeof sessionModel !== "undefined" ? sessionModel : null
                palette: palette
                fontFamily: themeFonts.uiFamily
                showBackground: false
            }

            Rectangle {
                width: 1
                height: parent.height - 8
                anchors.verticalCenter: parent.verticalCenter
                color: "#355174"
                opacity: 0.45
            }

            Power.PowerBar {
                id: powerBar
                height: parent.height
                palette: palette
                fontFamily: themeFonts.uiFamily
                showBackground: false
                onRequestSuspend: {
                    if (typeof sddm !== "undefined" && sddm) {
                        sddm.suspend()
                    } else {
                        root.statusText = "Test mode: suspend"
                        root.statusType = "info"
                    }
                }
                onRequestReboot: {
                    if (typeof sddm !== "undefined" && sddm) {
                        sddm.reboot()
                    } else {
                        root.statusText = "Test mode: reboot"
                        root.statusType = "info"
                    }
                }
                onRequestShutdown: {
                    if (typeof sddm !== "undefined" && sddm) {
                        sddm.powerOff()
                    } else {
                        root.statusText = "Test mode: shutdown"
                        root.statusType = "info"
                    }
                }
            }
        }
    }

    Connections {
        target: typeof sddm !== "undefined" ? sddm : null

        function onLoginSucceeded() {
            root.statusText = "Login successful"
            root.statusType = "ok"
        }

        function onLoginFailed() {
            root.statusText = "Invalid credentials"
            root.statusType = "error"
            loginPanel.clearPassword()
        }

        function onInformationMessage(message) {
            root.statusText = message
            root.statusType = "info"
        }

    }

    Behavior on opacity {
        NumberAnimation {
            duration: 320
            easing.type: Easing.OutCubic
        }
    }
}
