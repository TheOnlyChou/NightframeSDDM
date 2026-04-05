import QtQuick 2.15

QtObject {
    id: root

    property string accentOverride: ""
    property string secondaryAccentOverride: ""
    property string overlayTintOverride: ""
    property string panelTintOverride: ""

    readonly property color bgDeep: "#020812"
    readonly property color bgPanel: panelTint
    readonly property color bgPanelSoft: Qt.darker(panelTint, 1.18)
    readonly property color textPrimary: "#d9e7ff"
    readonly property color textMuted: "#8ea5c7"
    readonly property color textSubtle: "#7188a9"
    readonly property color danger: "#ff6b86"
    readonly property color success: "#8be6c5"
    readonly property color accent: accentOverride !== "" ? accentOverride : "#4ea0ff"
    readonly property color accentSecondary: secondaryAccentOverride !== "" ? secondaryAccentOverride : "#5f9edb"
    readonly property color overlayTint: overlayTintOverride !== "" ? overlayTintOverride : "#000000"
    readonly property color panelTint: panelTintOverride !== "" ? panelTintOverride : "#101a29"

    readonly property color borderSubtle: Qt.rgba(
        (accent.r * 0.35) + (panelTint.r * 0.65),
        (accent.g * 0.40) + (panelTint.g * 0.60),
        (accent.b * 0.55) + (panelTint.b * 0.45),
        0.52
    )
    readonly property color separatorSoft: Qt.rgba(
        (accentSecondary.r * 0.42) + (panelTint.r * 0.58),
        (accentSecondary.g * 0.42) + (panelTint.g * 0.58),
        (accentSecondary.b * 0.50) + (panelTint.b * 0.50),
        0.55
    )
    readonly property color panelGlass: Qt.rgba(panelTint.r, panelTint.g, panelTint.b, 0.34)
    readonly property color panelGlassStrong: Qt.rgba(panelTint.r, panelTint.g, panelTint.b, 0.52)
}
