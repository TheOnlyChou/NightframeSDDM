import QtQuick 2.15

QtObject {
    id: root

    readonly property int edgeMargin: Math.max(28, Screen.width * 0.035)
    readonly property int leftPanelMargin: Math.max(42, Screen.width * 0.075)
    readonly property int topInfoSpacing: 8
    readonly property int panelRadius: 14
    readonly property int loginPanelMaxWidth: 520
    readonly property int controlHeight: 46
    readonly property int controlRadius: 10
    readonly property int inputHeight: 54
    readonly property int buttonHeight: 46
    readonly property int floatingControlsHeight: 52
    readonly property int floatingControlsRadius: 12
    readonly property int floatingControlsPadding: 6
    readonly property int loginPanelInnerSpacing: 10
    readonly property int loginPanelSectionGap: 2
}
