pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls // Используем Control вместо Button
import qs.services
import qs.common
import qs.widgets
import Qt5Compat.GraphicalEffects

// ✅ 1. Заменяем Button на Control. Это устраняет весь конфликт.
Control {
    id: root

    // ✅ 2. Поскольку Control не имеет сигнала clicked, мы создаем его сами.
    signal clicked

    property bool toggled

    property string buttonText
    property int buttonTextWeight: 500
    property int buttonTextSize: 16
    property string buttonIcon
    property int buttonIconSize: 20
    property int buttonIconWeight: 500
    property real buttonRadius: 20
    property int buttonPadding

    // ✅ 3. Мы полностью контролируем состояния через MouseArea.
    //    `pressed` и `hovered` теперь - это чистые, надежные свойства.
    property bool pressed: mouseArea.pressed

    property color normalTextColor: Colors.palette.m3onSurface
    property color normalBg: Colors.palette.m3surfaceContainer
    property color normalHover: Colors.palette.m3surfaceContainerHighest
    // ✅ Используем наше надежное свойство `pressed`
    property color normalPress: Qt.lighter(Colors.palette.m3surfaceContainerHighest, 1.4)

    property color toggledTextColor: Colors.palette.m3surface
    property color toggledBg: Colors.palette.m3primary
    property color toggledHover: Qt.darker(Colors.palette.m3primary, 1.2)
    property color toggledPress: Qt.darker(Colors.palette.m3primary, 1.4)

    property color focusedBg: Colors.palette.m3primary
    property color focusedTextColor: Colors.palette.m3surface

    property color textColor: root.focus ? focusedTextColor : (toggled ? toggledTextColor : normalTextColor)
    // ✅ Эта формула теперь работает на 100% предсказуемых данных
    property color backgroundColor: root.focus ? focusedBg : (toggled ? (pressed ? toggledPress : (hovered ? toggledHover : toggledBg)) : (pressed ? normalPress : (hovered ? normalHover : normalBg)))

    property var onPress
    property var onRelease
    property var onAlt
    property var onMiddle

    property bool rippleEnabled: true
    property int rippleDuration: 1000
    property color normalRippleColor: Qt.rgba(normalTextColor.r, normalTextColor.g, normalTextColor.b, 0.1)
    property color toggledRippleColor: Qt.rgba(toggledTextColor.r, toggledTextColor.g, toggledTextColor.b, 0.25)
    property color focusedRippleColor: Qt.rgba(focusedTextColor.r, focusedTextColor.g, focusedTextColor.b, 0.25)
    property color rippleColor: root.focus ? focusedRippleColor : (toggled ? toggledRippleColor : normalRippleColor)

    property bool bounceEnabled: false

    padding: root.buttonPadding

    // topPadding: root.buttonPadding
    // bottomPadding: root.buttonPadding
    // leftPadding: root.buttonPadding
    // rightPadding: root.buttonPadding

    function startRipple(x, y) {
        if (!rippleEnabled)
            return;
        const stateY = backgroundRect.y;
        rippleAnim.x = x;
        rippleAnim.y = y - stateY;
        const dist = (ox, oy) => ox * ox + oy * oy;
        const stateEndY = stateY + backgroundRect.height;
        rippleAnim.radius = Math.sqrt(Math.max(dist(0, stateY), dist(0, stateEndY), dist(width, stateY), dist(width, stateEndY)));
        rippleFadeAnim.complete();
        rippleAnim.restart();
    }

    component RippleAnim: NumberAnimation {
        duration: root.rippleDuration
        easing.type: Easing.OutCubic
    }
    RippleAnim {
        id: rippleFadeAnim
        duration: root.rippleDuration / 2
        target: ripple
        property: "opacity"
        to: 0
    }
    SequentialAnimation {
        id: rippleAnim
        property real x
        property real y
        property real radius
        PropertyAction {
            target: ripple
            property: "x"
            value: rippleAnim.x
        }
        PropertyAction {
            target: ripple
            property: "y"
            value: rippleAnim.y
        }
        PropertyAction {
            target: ripple
            property: "opacity"
            value: 1
        }
        ParallelAnimation {
            RippleAnim {
                target: ripple
                properties: "implicitWidth,implicitHeight"
                from: 0
                to: rippleAnim.radius * 2
            }
        }
    }

    background: Rectangle {
        id: backgroundRect
        radius: root.buttonRadius
        color: root.backgroundColor
        Behavior on radius {
            NumberAnimation {
                duration: 100
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: backgroundRect.width
                height: backgroundRect.height
                radius: root.buttonRadius
            }
        }
        Item {
            id: ripple
            width: implicitWidth
            height: implicitHeight
            opacity: 0
            visible: width > 0 && height > 0
            property real implicitWidth: 0
            property real implicitHeight: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: root.rippleColor
                    }
                    GradientStop {
                        position: 0.3
                        color: root.rippleColor
                    }
                    GradientStop {
                        position: 0.5
                        color: Qt.rgba(root.rippleColor.r, root.rippleColor.g, root.rippleColor.b, 0)
                    }
                }
            }
            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }
    }

    contentItem: ColumnLayout {
        id: content
        spacing: 4
        anchors.centerIn: parent

        MaterialSymbol {
            visible: root.buttonIcon !== ""
            color: root.textColor
            icon: root.buttonIcon
            size: root.buttonIconSize
            Layout.alignment: Qt.AlignHCenter
            weight: root.buttonIconWeight
        }

        StyledText {
            visible: root.buttonText !== ""
            color: root.textColor
            text: root.buttonText
            weight: root.buttonTextWeight
            size: root.buttonTextSize
            Layout.alignment: Qt.AlignHCenter
        }
    }

    // ✅ 4. MouseArea теперь - ЕДИНСТВЕННЫЙ источник правды о состоянии кнопки.
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        // Нам нужно отслеживать наведение, поэтому hoverEnabled = true
        hoverEnabled: true

        onPressed: event => {
            switch (event.button) {
            case Qt.LeftButton:
                root.onPress?.();
                root.startRipple(event.x, event.y);
                break;
            case Qt.RightButton:
                root.onAlt?.();
                break;
            case Qt.MiddleButton:
                root.onMiddle?.();
                break;
            }
        }

        onReleased: event => {
            root.onRelease?.();
            if (root.rippleEnabled) {
                rippleFadeAnim.restart();
            }
        }

        // Когда MouseArea регистрирует клик, мы "пробрасываем" наш собственный сигнал.
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                root.clicked();
            }
        }
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            root.clicked();
            event.accepted = true;
        }
    }
}
