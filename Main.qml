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
        accentOverride: root.accentHex
    }

    Common.ThemeMetrics {
        id: metrics
    }

    Common.ThemeFonts {
        id: themeFonts
        pixelFontPath: Qt.resolvedUrl(root.pixelFontPath)
    }

    property string activePreset: (config.Preset || "default").toString().toLowerCase()

    function presetDefaults(presetName) {
        var presets = {
            "default": {
                AccentColor: "#4ea0ff",
                OverlayStrength: "0.46",
                PanelOpacity: "0.24",
                PanelRadius: "14",
                ControlDensity: "1.00",
                BackgroundMode: "image",
                UseVideo: "false",
                BackgroundImage: "assets/backgrounds/default.jpg",
                BackgroundVideo: "assets/video/nightframe.mp4",
                PixelFont: "assets/fonts/JetBrainsMono-Regular.ttf"
            },
            "night": {
                AccentColor: "#5f9edb",
                OverlayStrength: "0.50",
                PanelOpacity: "0.28",
                PanelRadius: "14",
                ControlDensity: "1.00",
                BackgroundMode: "image",
                UseVideo: "false",
                BackgroundImage: "assets/backgrounds/default.jpg",
                BackgroundVideo: "assets/video/nightframe.mp4",
                PixelFont: "assets/fonts/JetBrainsMono-Regular.ttf"
            },
            "pixel": {
                AccentColor: "#75c6ff",
                OverlayStrength: "0.44",
                PanelOpacity: "0.23",
                PanelRadius: "12",
                ControlDensity: "0.98",
                BackgroundMode: "image",
                UseVideo: "false",
                BackgroundImage: "assets/backgrounds/default.jpg",
                BackgroundVideo: "assets/video/nightframe.mp4",
                PixelFont: "assets/fonts/PressStart2P-Regular.ttf"
            },
            "rain": {
                AccentColor: "#7ba9d6",
                OverlayStrength: "0.52",
                PanelOpacity: "0.30",
                PanelRadius: "15",
                ControlDensity: "1.02",
                BackgroundMode: "image",
                UseVideo: "false",
                BackgroundImage: "assets/backgrounds/default.jpg",
                BackgroundVideo: "assets/video/nightframe.mp4",
                PixelFont: "assets/fonts/JetBrainsMono-Regular.ttf"
            }
        }
        return presets[presetName] || presets.default
    }

    function configOrPreset(key, fallback) {
        var directValue = config[key]
        if (directValue !== undefined && directValue !== null && directValue.toString() !== "") {
            return directValue.toString()
        }
        var fromPreset = presetDefaults(activePreset)[key]
        if (fromPreset !== undefined && fromPreset !== null && fromPreset.toString() !== "") {
            return fromPreset.toString()
        }
        return fallback
    }

    function configToBool(value, fallback) {
        if (value === undefined || value === null) {
            return fallback
        }
        if (typeof value === "boolean") {
            return value
        }
        return value.toString().toLowerCase() === "true"
    }

    property string accentHex: configOrPreset("AccentColor", "#4ea0ff")
    property string pixelFontPath: configOrPreset("PixelFont", "")

    property bool useVideoBackground: {
        var mode = configOrPreset("BackgroundMode", "image").toString().toLowerCase()
        var modeWantsVideo = mode === "video"
        var useVideoFlag = configToBool(configOrPreset("UseVideo", "false"), false)
        return useVideoFlag || modeWantsVideo
    }

    property url backgroundImagePath: Qt.resolvedUrl(configOrPreset("BackgroundImage", "assets/backgrounds/default.jpg"))
    property url backgroundVideoPath: Qt.resolvedUrl(configOrPreset("BackgroundVideo", "assets/video/nightframe.mp4"))
    property real overlayStrength: Number(configOrPreset("OverlayStrength", "0.46"))
    property real panelOpacity: Math.max(0.16, Math.min(0.42, Number(configOrPreset("PanelOpacity", "0.24"))))
    property int panelRadius: Math.max(10, Number(configOrPreset("PanelRadius", "14")))
    property real controlDensity: Math.max(0.92, Math.min(1.08, Number(configOrPreset("ControlDensity", "1.00"))))
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
        panelOpacity: root.panelOpacity
        panelRadius: root.panelRadius

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
        height: metrics.floatingControlsHeight * root.controlDensity
        radius: Math.max(metrics.floatingControlsRadius, root.panelRadius - 2)
        color: palette.panelGlassStrong
        opacity: Math.min(1.0, root.panelOpacity + 0.72)
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
                cornerRadius: Math.max(8, root.panelRadius - 4)
            }

            Rectangle {
                width: 1
                height: parent.height - 8
                anchors.verticalCenter: parent.verticalCenter
                color: palette.separatorSoft
                opacity: 0.45
            }

            Power.PowerBar {
                id: powerBar
                height: parent.height
                palette: palette
                fontFamily: themeFonts.uiFamily
                showBackground: false
                cornerRadius: Math.max(8, root.panelRadius - 4)
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
