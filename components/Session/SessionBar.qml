import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.15

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
    readonly property bool hasRealSessionModel: modelCount() > 0
    readonly property bool usingDemoFallback: !hasRealSessionModel && allowDemoFallback
    readonly property int selectedSessionIndex: hasRealSessionModel ? Math.max(0, Math.min(currentIndex, modelCount() - 1)) : -1
    readonly property string selectedSessionName: sessionNameAt(currentIndex)
    readonly property var loginSessionValue: {
        if (hasRealSessionModel) {
            // SDDM login accepts session index reliably across greeter/session model variants.
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

    function roleValue(modelObj, roleName) {
        if (!modelObj || !roleName || modelObj[roleName] === undefined || modelObj[roleName] === null) {
            return ""
        }
        var roleText = modelObj[roleName].toString().trim()
        return roleText.length > 0 ? roleText : ""
    }

    function resolveSessionIdentifier(modelObj, modelDataValue, fallbackName) {
        var candidates = [
            roleValue(modelObj, "key"),
            roleValue(modelObj, "id"),
            roleValue(modelObj, "desktopFile"),
            roleValue(modelObj, "fileName"),
            roleValue(modelObj, "exec"),
            roleValue(modelObj, "name"),
            (modelDataValue !== undefined && modelDataValue !== null) ? modelDataValue.toString().trim() : "",
            (fallbackName !== undefined && fallbackName !== null) ? fallbackName.toString().trim() : ""
        ]
        for (var i = 0; i < candidates.length; i++) {
            var value = candidates[i]
            if (value.length > 0) {
                return value
            }
        }
        return ""
    }

    function resolveSessionName(modelObj, modelDataValue) {
        var candidates = [
            roleValue(modelObj, "name"),
            roleValue(modelObj, "display"),
            roleValue(modelObj, "displayName"),
            roleValue(modelObj, "label"),
            roleValue(modelObj, "id"),
            roleValue(modelObj, "key"),
            (modelDataValue !== undefined && modelDataValue !== null) ? modelDataValue.toString().trim() : ""
        ]
        for (var i = 0; i < candidates.length; i++) {
            if (candidates[i].length > 0) {
                return candidates[i]
            }
        }
        return ""
    }

    function modelEntryAt(index) {
        if (!hasRealSessionModel || index < 0 || index >= modelCount()) {
            return null
        }
        var obj = sessionEntries.objectAt(index)
        if (!obj) {
            return null
        }
        return {
            name: obj.sessionName,
            identifier: obj.sessionIdentifier
        }
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
            var entry = modelEntryAt(index)
            if (entry && entry.name.length > 0) {
                return entry.name
            }
            return emptySessionLabel
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

    Instantiator {
        id: sessionEntries
        model: root.hasRealSessionModel ? root.sessionModelRef : null
        delegate: QtObject {
            required property var model
            required property var modelData

            readonly property string sessionName: root.resolveSessionName(model, modelData)
            readonly property string sessionIdentifier: root.resolveSessionIdentifier(model, modelData, sessionName)
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
            model: root.hasRealSessionModel ? root.sessionModelRef : (root.usingDemoFallback ? root.effectiveDemoList() : [])
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
                    text: root.hasRealSessionModel
                          ? root.resolveSessionName(model, modelData)
                          : (modelData !== undefined && modelData !== null ? modelData.toString() : root.emptySessionLabel)
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
