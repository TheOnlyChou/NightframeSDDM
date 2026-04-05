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
        secondaryAccentOverride: root.secondaryAccentHex
        overlayTintOverride: root.overlayTintHex
        panelTintOverride: root.panelTintHex
    }

    Common.ThemeMetrics {
        id: metrics
    }

    Common.ThemeFonts {
        id: themeFonts
        uiFontPath: Qt.resolvedUrl(root.uiFontPath)
        clockFontPath: Qt.resolvedUrl(root.clockFontPath)
        pixelFontPath: Qt.resolvedUrl(root.pixelFontPath)
    }

    property string activePreset: (config.Preset || "default").toString().toLowerCase()

    function presetDefaults(presetName) {
        var presets = {
            "default": {
                AccentColor: "#56d4e2",
                SecondaryAccentColor: "#7ebfff",
                OverlayStrength: "0.40",
                OverlayTint: "#081b2d",
                PanelTint: "#101a2a",
                PanelOpacity: "0.23",
                PanelRadius: "14",
                ControlDensity: "1.00",
                ClockScale: "1.00",
                TitleOpacity: "0.98",
                SubtitleOpacity: "0.86",
                BottomControlsOpacity: "0.94",
                PanelHorizontalOffset: "0",
                PanelVerticalOffset: "0",
                SessionStyle: "balanced",
                TransitionProfile: "default",
                ControlSpacing: "10",
                PanelBorderStrength: "1.00",
                BackgroundMode: "image",
                UseVideo: "false",
                BackgroundImage: "assets/backgrounds/default.jpg",
                BackgroundVideo: "assets/video/pixel.mp4",
                UiFont: "assets/fonts/Poppins-Regular.ttf",
                ClockFont: "assets/fonts/JetBrainsMono-Regular.ttf",
                PixelFont: ""
            },
            "night": {
                AccentColor: "#78b8ff",
                SecondaryAccentColor: "#5f9edb",
                OverlayStrength: "0.56",
                OverlayTint: "#030a1f",
                PanelTint: "#0a1220",
                PanelOpacity: "0.29",
                PanelRadius: "10",
                ControlDensity: "0.94",
                ClockScale: "0.96",
                TitleOpacity: "0.95",
                SubtitleOpacity: "0.72",
                BottomControlsOpacity: "0.88",
                PanelHorizontalOffset: "36",
                PanelVerticalOffset: "-14",
                SessionStyle: "minimal",
                TransitionProfile: "night",
                ControlSpacing: "8",
                PanelBorderStrength: "1.20",
                BackgroundMode: "image",
                UseVideo: "false",
                BackgroundImage: "assets/backgrounds/night.jpg",
                BackgroundVideo: "assets/video/pixel.mp4",
                UiFont: "assets/fonts/SpaceGrotesk-Regular.ttf",
                ClockFont: "assets/fonts/JetBrainsMono-Regular.ttf",
                PixelFont: ""
            },
            "pixel": {
                AccentColor: "#5cf2ff",
                SecondaryAccentColor: "#ff4fd8",
                OverlayStrength: "0.36",
                OverlayTint: "#150a27",
                PanelTint: "#170c2c",
                PanelOpacity: "0.22",
                PanelRadius: "6",
                ControlDensity: "0.90",
                ClockScale: "0.72",
                TitleOpacity: "1.00",
                SubtitleOpacity: "0.78",
                BottomControlsOpacity: "1.00",
                PanelHorizontalOffset: "26",
                PanelVerticalOffset: "-8",
                SessionStyle: "pixel",
                TransitionProfile: "pixel",
                ControlSpacing: "6",
                PanelBorderStrength: "1.35",
                BackgroundMode: "video",
                UseVideo: "true",
                BackgroundImage: "assets/backgrounds/night.jpg",
                BackgroundVideo: "assets/video/pixel.mp4",
                UiFont: "assets/fonts/Poppins-Regular.ttf",
                ClockFont: "assets/fonts/PressStart2P-Regular.ttf",
                PixelFont: "assets/fonts/PressStart2P-Regular.ttf"
            },
            "rain": {
                AccentColor: "#9bbad0",
                SecondaryAccentColor: "#8ba8c1",
                OverlayStrength: "0.58",
                OverlayTint: "#121b28",
                PanelTint: "#1b2532",
                PanelOpacity: "0.34",
                PanelRadius: "20",
                ControlDensity: "1.06",
                ClockScale: "0.94",
                TitleOpacity: "0.92",
                SubtitleOpacity: "0.82",
                BottomControlsOpacity: "0.90",
                PanelHorizontalOffset: "18",
                PanelVerticalOffset: "10",
                SessionStyle: "soft",
                TransitionProfile: "rain",
                ControlSpacing: "12",
                PanelBorderStrength: "0.82",
                BackgroundMode: "image",
                UseVideo: "false",
                BackgroundImage: "assets/backgrounds/rain.jpg",
                BackgroundVideo: "assets/video/pixel.mp4",
                UiFont: "assets/fonts/IBMPlexSans-Regular.ttf",
                ClockFont: "assets/fonts/JetBrainsMono-Regular.ttf",
                PixelFont: ""
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

    function configToNumber(value, fallback) {
        var n = Number(value)
        return isNaN(n) ? fallback : n
    }

    property string accentHex: configOrPreset("AccentColor", "#4ea0ff")
    property string secondaryAccentHex: configOrPreset("SecondaryAccentColor", "#5f9edb")
    property string overlayTintHex: configOrPreset("OverlayTint", "#000000")
    property string panelTintHex: configOrPreset("PanelTint", "#121f33")

    property string uiFontPath: configOrPreset("UiFont", "")
    property string clockFontPath: configOrPreset("ClockFont", configOrPreset("PixelFont", ""))
    property string pixelFontPath: configOrPreset("PixelFont", "")

    property bool useVideoBackground: {
        var mode = configOrPreset("BackgroundMode", "image").toString().toLowerCase()
        var modeWantsVideo = mode === "video"
        var useVideoFlag = configToBool(configOrPreset("UseVideo", "false"), false)
        return useVideoFlag || modeWantsVideo
    }

    property url backgroundImagePath: Qt.resolvedUrl(configOrPreset("BackgroundImage", "assets/backgrounds/default.jpg"))
    property url backgroundVideoPath: Qt.resolvedUrl(configOrPreset("BackgroundVideo", "assets/video/pixel.mp4"))
    property real overlayStrength: Math.max(0.20, Math.min(0.70, configToNumber(configOrPreset("OverlayStrength", "0.46"), 0.46)))
    property real panelOpacity: Math.max(0.16, Math.min(0.46, configToNumber(configOrPreset("PanelOpacity", "0.24"), 0.24)))
    property int panelRadius: Math.max(4, configToNumber(configOrPreset("PanelRadius", "14"), 14))
    property real controlDensity: Math.max(0.84, Math.min(1.16, configToNumber(configOrPreset("ControlDensity", "1.00"), 1.0)))
    property real clockScale: Math.max(0.68, Math.min(1.15, configToNumber(configOrPreset("ClockScale", "1.00"), 1.0)))
    property real titleOpacity: Math.max(0.65, Math.min(1.0, configToNumber(configOrPreset("TitleOpacity", "0.96"), 0.96)))
    property real subtitleOpacity: Math.max(0.55, Math.min(1.0, configToNumber(configOrPreset("SubtitleOpacity", "0.82"), 0.82)))
    property real bottomControlsOpacity: Math.max(0.72, Math.min(1.0, configToNumber(configOrPreset("BottomControlsOpacity", "0.92"), 0.92)))
    property int panelHorizontalOffset: configToNumber(configOrPreset("PanelHorizontalOffset", "0"), 0)
    property int panelVerticalOffset: configToNumber(configOrPreset("PanelVerticalOffset", "0"), 0)
    property string sessionStyle: configOrPreset("SessionStyle", "balanced").toString().toLowerCase()
    property int controlSpacing: Math.max(4, configToNumber(configOrPreset("ControlSpacing", "10"), 10))
    property real panelBorderStrength: Math.max(0.7, Math.min(1.4, configToNumber(configOrPreset("PanelBorderStrength", "1.0"), 1.0)))
    property string transitionProfile: configOrPreset("TransitionProfile", activePreset).toString().toLowerCase()
    property int introDuration: {
        if (transitionProfile === "night") {
            return 620
        }
        if (transitionProfile === "rain") {
            return 700
        }
        if (transitionProfile === "pixel") {
            return 380
        }
        return 480
    }
    property int introGap: {
        if (transitionProfile === "night") {
            return 120
        }
        if (transitionProfile === "rain") {
            return 130
        }
        if (transitionProfile === "pixel") {
            return 70
        }
        return 95
    }
    property bool use24hClock: {
        if (typeof config.Clock24h === "boolean") {
            return config.Clock24h
        }
        return (config.Clock24h || "true").toString().toLowerCase() !== "false"
    }

    property string statusText: ""
    property string statusType: "info"
    property bool authenticating: false
    property bool videoPlaybackFailed: false
    property bool testMode: typeof sddm === "undefined" || !sddm
    property bool authDebugEnabled: testMode || configToBool(configOrPreset("DebugAuthFlow", "false"), false)
    property int authAttemptCount: 0
    property string runtimeModeLabel: testMode ? "Preview mode (no PAM/fprintd)" : "SDDM runtime mode"
    property string authAttemptNote: ""

    function beginAuthenticationAttempt(userName, password) {
        if (root.authenticating) {
            return
        }

        var normalizedUser = userName ? userName.toString().trim() : ""
        if (normalizedUser.length === 0) {
            root.statusText = "Select a user to authenticate"
            root.statusType = "info"
            return
        }

        root.authenticating = true
        root.authAttemptCount = root.authAttemptCount + 1
        root.authAttemptNote = "Authentication attempt #" + root.authAttemptCount

        if (root.testMode) {
            root.statusText = "Preview mode only: login UI event triggered, but PAM/fprintd is not executed in --test-mode"
            root.statusType = "info"
            previewAuthTimer.restart()
            return
        }

        if (root.authDebugEnabled) {
            root.statusText = "Authentication requested via SDDM"
            root.statusType = "info"
        } else {
            root.statusText = ""
            root.statusType = "info"
        }

        sddm.login(normalizedUser, password, sessionBar.loginSessionValue)
    }

    Timer {
        id: previewAuthTimer
        interval: 1200
        repeat: false
        onTriggered: {
            root.authenticating = false
            root.statusText = "Preview mode limitation: test with installed SDDM greeter for real password/fingerprint PAM authentication"
            root.statusType = "info"
            loginPanel.clearPassword()
        }
    }

    property var keyboardLayoutModelRef: {
        if (typeof keyboardLayoutModel !== "undefined") {
            return keyboardLayoutModel
        }
        if (typeof keyboardModel !== "undefined") {
            return keyboardModel
        }
        return null
    }
    property int keyboardLayoutIndex: 0
    function keyboardLayoutCount() {
        return keyboardLayoutModelRef && keyboardLayoutModelRef.count ? keyboardLayoutModelRef.count : 0
    }

    function keyboardLayoutNameAt(index) {
        if (!keyboardLayoutModelRef || typeof keyboardLayoutModelRef.get !== "function" || index < 0 || index >= keyboardLayoutCount()) {
            if (typeof keyboardLayout !== "undefined" && keyboardLayout) {
                return keyboardLayout.toString()
            }
            return "Layout"
        }
        var layoutEntry = keyboardLayoutModelRef.get(index)
        if (!layoutEntry) {
            return "Layout"
        }
        return (layoutEntry.shortName || layoutEntry.name || layoutEntry.layout || "Layout").toString()
    }

    function setKeyboardLayout(index) {
        if (index < 0 || index >= keyboardLayoutCount()) {
            return
        }
        keyboardLayoutIndex = index

        if (keyboardLayoutModelRef && typeof keyboardLayoutModelRef.setCurrentIndex === "function") {
            keyboardLayoutModelRef.setCurrentIndex(index)
            return
        }

        if (keyboardLayoutModelRef && keyboardLayoutModelRef.currentIndex !== undefined) {
            keyboardLayoutModelRef.currentIndex = index
            return
        }

        if (typeof sddm !== "undefined" && sddm && typeof sddm.setLayout === "function") {
            sddm.setLayout(keyboardLayoutNameAt(index))
            return
        }

        root.statusText = "Keyboard layout switching not exposed by this greeter build"
        root.statusType = "info"
    }

    Component.onCompleted: {
        if (keyboardLayoutModelRef && keyboardLayoutModelRef.currentIndex !== undefined) {
            keyboardLayoutIndex = Math.max(0, keyboardLayoutModelRef.currentIndex)
        }
    }

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
        overlayColor: palette.overlayTint
    }

    Rectangle {
        anchors.fill: parent
        visible: root.sessionStyle === "night"
        color: palette.accent
        opacity: 0.035
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(palette.accent.r, palette.accent.g, palette.accent.b, 0.28) }
            GradientStop { position: 0.45; color: Qt.rgba(palette.accent.r, palette.accent.g, palette.accent.b, 0.06) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.0) }
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: root.sessionStyle === "soft"
        color: "#dce6f2"
        opacity: 0.032
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.88, 0.91, 0.95, 0.18) }
            GradientStop { position: 0.4; color: Qt.rgba(0.76, 0.82, 0.88, 0.10) }
            GradientStop { position: 1.0; color: Qt.rgba(0.0, 0.0, 0.0, 0.0) }
        }
    }

    Item {
        id: pixelScanlines
        anchors.fill: parent
        visible: root.sessionStyle === "pixel"
        opacity: 0.055

        Repeater {
            model: Math.ceil(pixelScanlines.height / 4)

            Rectangle {
                x: 0
                y: index * 4
                width: pixelScanlines.width
                height: 1
                color: index % 2 === 0 ? "#7befff" : "#ff67dd"
                opacity: index % 2 === 0 ? 0.12 : 0.09
            }
        }
    }

    Column {
        id: topLeftInfo
        spacing: 8
        opacity: 0.0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: metrics.edgeMargin
        anchors.topMargin: metrics.edgeMargin

        SequentialAnimation on opacity {
            running: true
            loops: 1

            PauseAnimation {
                duration: 40
            }

            NumberAnimation {
                to: 1.0
                duration: root.introDuration
                easing.type: transitionProfile === "pixel" ? Easing.OutQuad : Easing.OutCubic
            }
        }

        Widgets.ClockBlock {
            id: clockBlock
            use24h: root.use24hClock
            fontFamily: themeFonts.clockFamily
            textColor: palette.textPrimary
            scaleFactor: root.clockScale
            styleVariant: root.sessionStyle
        }

        Widgets.DateBlock {
            textColor: palette.textMuted
            fontFamily: themeFonts.uiFamily
            textOpacity: root.subtitleOpacity
        }
    }

    Rectangle {
        id: runtimeBadge
        visible: root.authDebugEnabled
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: metrics.edgeMargin
        anchors.rightMargin: metrics.edgeMargin
        width: runtimeBadgeText.implicitWidth + Math.round(18 * root.controlDensity)
        height: Math.round(28 * root.controlDensity)
        radius: Math.max(6, Math.round(root.panelRadius * 0.6))
        color: palette.panelGlassStrong
        opacity: 0.92
        border.width: 1
        border.color: root.testMode ? "#d89a4d" : palette.borderSubtle

        Text {
            id: runtimeBadgeText
            anchors.centerIn: parent
            text: root.runtimeModeLabel
            color: root.testMode ? "#ffd9a6" : palette.textMuted
            font.family: themeFonts.uiFamily
            font.pixelSize: Math.round(11 * root.controlDensity)
            font.bold: root.testMode
        }
    }

    Auth.LoginPanel {
        id: loginPanel
        opacity: 0.0
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: metrics.leftPanelMargin + root.panelHorizontalOffset
        anchors.verticalCenterOffset: root.panelVerticalOffset
        width: Math.min(metrics.loginPanelMaxWidth, parent.width * 0.34)

        userModelRef: typeof userModel !== "undefined" ? userModel : null
        messageText: root.statusText
        messageType: root.statusType
        authenticating: root.authenticating
        showDebugInfo: root.authDebugEnabled
        runtimeModeText: root.runtimeModeLabel
        authStateText: root.authAttemptNote
        palette: palette
        fontFamily: themeFonts.uiFamily
        panelOpacity: root.panelOpacity
        panelRadius: root.panelRadius
        controlDensity: root.controlDensity
        titleOpacity: root.titleOpacity
        subtitleOpacity: root.subtitleOpacity
        controlSpacing: root.controlSpacing
        panelBorderStrength: root.panelBorderStrength
        styleVariant: root.sessionStyle

        SequentialAnimation on opacity {
            running: true
            loops: 1

            PauseAnimation {
                duration: 40 + root.introGap
            }

            NumberAnimation {
                to: 1.0
                duration: root.introDuration
                easing.type: transitionProfile === "pixel" ? Easing.OutQuad : Easing.OutCubic
            }
        }

        onLoginRequested: function(userName, password) {
            root.beginAuthenticationAttempt(userName, password)
        }
    }

    Rectangle {
        id: bottomRightControls
        opacity: 0.0
        height: Math.round(metrics.floatingControlsHeight * root.controlDensity)
        radius: Math.max(4, root.panelRadius - 2)
        color: palette.panelGlassStrong
        readonly property real targetOpacity: root.bottomControlsOpacity
        border.width: Math.max(1, Math.round(root.panelBorderStrength))
        border.color: palette.borderSubtle
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: metrics.edgeMargin
        anchors.bottomMargin: metrics.edgeMargin
        width: controlsRow.implicitWidth + metrics.floatingControlsPadding * 2

        SequentialAnimation on opacity {
            running: true
            loops: 1

            PauseAnimation {
                duration: 40 + (root.introGap * 2)
            }

            NumberAnimation {
                to: bottomRightControls.targetOpacity
                duration: root.introDuration
                easing.type: transitionProfile === "pixel" ? Easing.OutQuad : Easing.OutCubic
            }
        }

        Row {
            id: controlsRow
            anchors.fill: parent
            anchors.margins: metrics.floatingControlsPadding
            spacing: root.controlSpacing

            Session.SessionBar {
                id: sessionBar
                height: parent.height
                sessionModelRef: typeof sessionModel !== "undefined" ? sessionModel : null
                allowDemoFallback: root.testMode
                palette: palette
                fontFamily: themeFonts.uiFamily
                showBackground: false
                cornerRadius: Math.max(8, root.panelRadius - 4)
                controlDensity: root.controlDensity
                styleVariant: root.sessionStyle
                panelBorderStrength: root.panelBorderStrength
            }

            Rectangle {
                width: 1
                height: parent.height - 8
                anchors.verticalCenter: parent.verticalCenter
                color: palette.separatorSoft
                opacity: 0.45
            }

            Item {
                id: keyboardLayoutControl
                visible: root.keyboardLayoutCount() > 0 || (typeof keyboardLayout !== "undefined" && keyboardLayout)
                width: Math.round(metrics.compactSelectorWidth * root.controlDensity)
                height: parent.height

                readonly property bool hovered: keyboardLayoutArea.containsMouse
                readonly property bool menuOpen: keyboardLayoutPopup.visible

                Rectangle {
                    anchors.fill: parent
                    radius: Math.max(8, root.panelRadius - 4)
                    color: keyboardLayoutControl.menuOpen
                           ? (root.sessionStyle === "pixel" ? "#2f2560" : "#2a3f5a")
                           : (keyboardLayoutControl.hovered ? "#24364c" : "transparent")
                    border.width: 1
                    border.color: (keyboardLayoutControl.hovered || keyboardLayoutControl.menuOpen)
                                  ? palette.accent
                                  : palette.borderSubtle
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.keyboardLayoutNameAt(root.keyboardLayoutIndex)
                    color: palette.textPrimary
                    font.family: themeFonts.uiFamily
                    font.pixelSize: Math.round(12 * root.controlDensity)
                    elide: Text.ElideRight
                    width: parent.width - 26
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    text: keyboardLayoutControl.menuOpen ? "▴" : "▾"
                    color: palette.textMuted
                    font.family: themeFonts.uiFamily
                    font.pixelSize: Math.round(11 * root.controlDensity)
                }

                MouseArea {
                    id: keyboardLayoutArea
                    anchors.fill: parent
                    enabled: root.keyboardLayoutCount() > 1
                    hoverEnabled: true
                    onClicked: {
                        if (keyboardLayoutPopup.visible) {
                            keyboardLayoutPopup.close()
                        } else {
                            keyboardLayoutPopup.open()
                        }
                    }
                }

                Popup {
                    id: keyboardLayoutPopup
                    x: keyboardLayoutControl.x
                    y: keyboardLayoutControl.y - height + 2
                    width: keyboardLayoutControl.width
                    height: Math.min(
                                Math.max(1, root.keyboardLayoutCount()) * Math.round(32 * root.controlDensity) + 10,
                                Math.round(Math.min(metrics.compactListMaxHeight, 176) * root.controlDensity)
                            )
                    modal: false
                    focus: true
                    padding: 4
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

                    background: Rectangle {
                        radius: Math.max(6, root.panelRadius - 3)
                        color: palette.panelGlassStrong
                        border.width: Math.max(1, Math.round(root.panelBorderStrength))
                        border.color: palette.borderSubtle
                    }

                    ListView {
                        anchors.fill: parent
                        clip: true
                        model: root.keyboardLayoutCount()

                        delegate: Rectangle {
                            width: parent.width
                            height: Math.round(32 * root.controlDensity)
                            radius: Math.max(4, root.panelRadius - 6)
                            color: index === root.keyboardLayoutIndex
                                   ? (root.sessionStyle === "pixel" ? "#3a2c69" : "#2b3f5c")
                                   : (layoutDelegateArea.containsMouse ? "#22344a" : "transparent")

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.keyboardLayoutNameAt(index)
                                color: palette.textPrimary
                                font.family: themeFonts.uiFamily
                                font.pixelSize: Math.round(12 * root.controlDensity)
                                elide: Text.ElideRight
                                width: parent.width - 16
                            }

                            MouseArea {
                                id: layoutDelegateArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    root.setKeyboardLayout(index)
                                    keyboardLayoutPopup.close()
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                visible: keyboardLayoutControl.visible
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
                controlDensity: root.controlDensity
                styleVariant: root.sessionStyle
                panelBorderStrength: root.panelBorderStrength
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
            previewAuthTimer.stop()
            root.authenticating = false
            root.statusText = root.authDebugEnabled ? "Authentication succeeded" : ""
            root.statusType = "info"
        }

        function onLoginFailed() {
            previewAuthTimer.stop()
            root.authenticating = false
            root.statusText = "Invalid credentials"
            root.statusType = "error"
            loginPanel.clearPassword()
        }

        function onInformationMessage(message) {
            previewAuthTimer.stop()
            root.authenticating = false
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
