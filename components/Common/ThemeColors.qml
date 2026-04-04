import QtQuick 2.15

QtObject {
    id: root

    property string accentOverride: ""

    readonly property color bgDeep: "#020812"
    readonly property color bgPanel: "#101a29"
    readonly property color bgPanelSoft: "#0a1320"
    readonly property color textPrimary: "#d9e7ff"
    readonly property color textMuted: "#8ea5c7"
    readonly property color danger: "#ff6b86"
    readonly property color success: "#8be6c5"
    readonly property color borderSubtle: "#2a3f5f"
    readonly property color accent: accentOverride !== "" ? accentOverride : "#4ea0ff"
}
