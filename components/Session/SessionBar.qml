import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property var sessionModelRef: null
    property bool allowDemoFallback: false
    property var palette: null
    property string fontFamily: "Noto Sans"
    property int currentIndex: 0
    property string demoSessionName: "Hyprland"
    property var demoSessionList: ["Hyprland", "GNOME", "Plasma"]
    property string emptySessionLabel: "No session"
    property bool showBackground: true
    property int cornerRadius: 8
    property real controlDensity: 1.0
    property string styleVariant: "balanced"
    property real panelBorderStrength: 1.0

    readonly property bool hovered: hoverArea.containsMouse
    readonly property bool menuOpen: sessionPopup.visible
    readonly property bool hasRealSessionModel: modelCount() > 0 && typeof sessionModelRef.get === "function"
    readonly property bool usingDemoFallback: !hasRealSessionModel && allowDemoFallback
    readonly property int selectedSessionIndex: hasRealSessionModel ? Math.max(0, Math.min(currentIndex, modelCount() - 1)) : -1
    readonly property string selectedSessionName: sessionNameAt(currentIndex)
    readonly property string selectedSessionIdentifier: hasRealSessionModel ? modelSessionIdentifierAt(selectedSessionIndex) : ""
    readonly property var loginSessionValue: {
        if (hasRealSessionModel) {
            if (selectedSessionIdentifier.length > 0) {
                return selectedSessionIdentifier
            }
            return selectedSessionIndex
        }
        if (usingDemoFallback) {
            return selectedSessionName
        }
        return ""
    }

    width: Math.round((styleVariant === "pixel" ? 236 : 250) * controlDensity)
    height: Math.round(40 * controlDensity)

    function modelCount() {
        return sessionModelRef && sessionModelRef.count ? sessionModelRef.count : 0
    }

    function modelSessionAt(index) {
        if (!hasRealSessionModel || index < 0 || index >= modelCount()) {
            return null
        }
        return sessionModelRef.get(index)
    }

    function modelSessionIdentifierFromEntry(entry) {
        if (!entry) {
            return ""
        }
        var candidates = [entry.key, entry.id, entry.desktopFile, entry.fileName, entry.exec, entry.name]
        for (var i = 0; i < candidates.length; i++) {
            var value = candidates[i]
            if (value !== undefined && value !== null && value.toString().trim().length > 0) {
                return value.toString()
            }
        }
        return ""
    }

    function modelSessionNameAt(index) {
        var s = modelSessionAt(index)
        if (!s) {
            return ""
        }
        if (s.name !== undefined && s.name !== null && s.name.toString().trim().length > 0) {
            return s.name.toString()
        }
        return modelSessionIdentifierFromEntry(s)
    }

    function modelSessionIdentifierAt(index) {
        var s = modelSessionAt(index)
        return modelSessionIdentifierFromEntry(s)
    }

    function effectiveDemoList() {
        if (demoSessionList && demoSessionList.length > 0) {
            return demoSessionList
        }
        return [demoSessionName]
    }

    function sessionCount() {
        if (hasRealSessionModel) {
            return modelCount()
        }
        if (usingDemoFallback) {
            return effectiveDemoList().length
        }
        return 0
    }

    function sessionNameAt(index) {
        if (index < 0 || index >= sessionCount()) {
            return emptySessionLabel
        }
        if (hasRealSessionModel) {
            return modelSessionNameAt(index)
        }
        var demoList = effectiveDemoList()
        return demoList[index] || emptySessionLabel
    }

    function modelPreferredIndex() {
        if (!hasRealSessionModel) {
            return 0
        }
        var candidates = [
            sessionModelRef.currentIndex,
            sessionModelRef.lastIndex,
            sessionModelRef.index,
            sessionModelRef.defaultIndex
        ]
        for (var i = 0; i < candidates.length; i++) {
            var idx = Number(candidates[i])
            if (!isNaN(idx) && idx >= 0 && idx < modelCount()) {
                return Math.floor(idx)
            }
        }
        return 0
    }

    function setCurrentIndexFromUI(index) {
        if (sessionCount() <= 0) {
            currentIndex = 0
            return
        }

        var clamped = Math.max(0, Math.min(index, sessionCount() - 1))
        currentIndex = clamped

        if (hasRealSessionModel) {
            if (typeof sessionModelRef.setCurrentIndex === "function") {
                sessionModelRef.setCurrentIndex(clamped)
            } else if (sessionModelRef.currentIndex !== undefined) {
                sessionModelRef.currentIndex = clamped
            } else if (sessionModelRef.index !== undefined) {
                sessionModelRef.index = clamped
            }
        }
    }

    function syncSelectionFromModel(preferModelIndex) {
        if (hasRealSessionModel) {
            var target = preferModelIndex ? modelPreferredIndex() : currentIndex
            currentIndex = Math.max(0, Math.min(target, modelCount() - 1))
            return
        }
        if (usingDemoFallback) {
            currentIndex = Math.max(0, Math.min(currentIndex, sessionCount() - 1))
            return
        }
        currentIndex = 0
    }

    Component.onCompleted: {
        syncSelectionFromModel(true)
    }

    onSessionModelRefChanged: syncSelectionFromModel(true)
    onAllowDemoFallbackChanged: syncSelectionFromModel(true)

    Connections {
        target: root.sessionModelRef
        ignoreUnknownSignals: true

        function onCountChanged() {
            root.syncSelectionFromModel(true)
        }

        function onCurrentIndexChanged() {
            root.syncSelectionFromModel(true)
        }

        function onLastIndexChanged() {
            root.syncSelectionFromModel(true)
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
            text: root.sessionCount() > 0 ? root.sessionNameAt(root.currentIndex) : root.emptySessionLabel
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
                        root.setCurrentIndexFromUI(index)
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
