pragma Singleton
import QtQuick

QtObject {
    <* for name, value in colors *>
    property color {{name}}: "{{value.default.hex}}"
    <* endfor *>
}
