pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.modules.common
import qs.services
import qs.config

Item {
    id: root

    required property string expression
    property bool transparent: Config.appearance.transparency.enabled
    property real alpha: Config.appearance.transparency.alpha

    readonly property int count: 1

    // Use launcher item height to ensure ListView gets a sane value (avoid NaN from row.implicitHeight)
    implicitHeight: Math.max(Config.launcher.sizes.itemHeight, (row ? (row.implicitHeight || 0) : 0) + Appearance.padding.large * 2)

    function evaluate(expr) {
        const trimmed = expr.trim();
        if (trimmed.length === 0)
            return {
                ok: false,
                message: "Empty expression"
            };

        try {
            const tokens = tokenize(trimmed);
            console.log("Tokens:", JSON.stringify(tokens));
            const rpn = toRpn(tokens);
            const value = evalRpn(rpn);
            if (!isFinite(value))
                return {
                    ok: false,
                    message: "Invalid expression"
                };

            const formatted = Number.isInteger(value) ? value.toString() : value.toFixed(6).replace(/\\.0+$/, "").replace(/(\\.\\d*?)0+$/, "$1");
            return {
                ok: true,
                message: formatted
            };
        } catch (e) {
            return {
                ok: false,
                message: "Invalid expression"
            };
        }
    }

    function tokenize(str) {
        const tokens = [];
        let i = 0;

        const pushNumber = numStr => {
            if (numStr === "" || numStr === "-" || numStr === "+")
                throw new Error("invalid number");
            let value = parseFloat(numStr);
            if (Number.isNaN(value))
                throw new Error("nan");
            // Percent directly after number: 25% -> 0.25
            if (str[i] === "%") {
                value = value / 100;
                i++;
            }
            tokens.push({
                type: "number",
                value
            });
        };

        while (i < str.length) {
            const ch = str[i];

            if (ch === " " || ch === "\\t" || ch === "\\n") {
                i++;
                continue;
            }

            if ("+-".includes(ch)) {
                // Unary if at start or after operator/left paren
                const prev = tokens[tokens.length - 1];
                if (!prev || (prev.type === "op" && prev.value !== "%") || (prev.type === "paren" && prev.value === "(")) {
                    let num = ch;
                    i++;
                    while (i < str.length && /[0-9.]/.test(str[i])) {
                        num += str[i++];
                    }
                    pushNumber(num);
                    continue;
                }
                tokens.push({
                    type: "op",
                    value: ch
                });
                i++;
                continue;
            }

            if ("*/^".includes(ch)) {
                tokens.push({
                    type: "op",
                    value: ch
                });
                i++;
                continue;
            }

            if (ch === "%") {
                tokens.push({
                    type: "op",
                    value: ch
                });
                i++;
                continue;
            }

            if (ch === "(" || ch === ")") {
                tokens.push({
                    type: "paren",
                    value: ch
                });
                i++;
                continue;
            }

            if (/[0-9.]/.test(ch)) {
                let num = "";
                while (i < str.length && /[0-9.]/.test(str[i])) {
                    num += str[i++];
                }
                pushNumber(num);
                continue;
            }

            throw new Error("bad char");
        }

        return tokens;
    }

    function toRpn(tokens) {
        const output = [];
        const ops = [];
        const precedence = {
            "^": 4,
            "*": 3,
            "/": 3,
            "%": 3,
            "+": 2,
            "-": 2
        };
        const rightAssoc = {
            "^": true
        };

        for (let i = 0; i < tokens.length; i++) {
            const t = tokens[i];
            if (t.type === "number") {
                output.push(t);
            } else if (t.type === "op") {
                while (ops.length > 0) {
                    const top = ops[ops.length - 1];
                    if (top.type !== "op")
                        break;
                    if ((rightAssoc[t.value] && precedence[t.value] < precedence[top.value]) || (!rightAssoc[t.value] && precedence[t.value] <= precedence[top.value])) {
                        output.push(ops.pop());
                    } else {
                        break;
                    }
                }
                ops.push(t);
            } else if (t.type === "paren" && t.value === "(") {
                ops.push(t);
            } else if (t.type === "paren" && t.value === ")") {
                while (ops.length > 0 && !(ops[ops.length - 1].type === "paren" && ops[ops.length - 1].value === "(")) {
                    output.push(ops.pop());
                }
                if (ops.length === 0)
                    throw new Error("mismatched paren");
                ops.pop();
            }
        }

        while (ops.length > 0) {
            const op = ops.pop();
            if (op.type === "paren")
                throw new Error("mismatched paren");
            output.push(op);
        }

        return output;
    }

    function evalRpn(rpn) {
        const stack = [];
        for (let i = 0; i < rpn.length; i++) {
            const t = rpn[i];
            if (t.type === "number") {
                stack.push(t.value);
            } else if (t.type === "op") {
                if (stack.length < 2)
                    throw new Error("stack underflow");
                const b = stack.pop();
                const a = stack.pop();
                let res = 0;
                switch (t.value) {
                case "+":
                    res = a + b;
                    break;
                case "-":
                    res = a - b;
                    break;
                case "*":
                    res = a * b;
                    break;
                case "/":
                    res = a / b;
                    break;
                case "^":
                    res = Math.pow(a, b);
                    break;
                case "%":
                    res = a * (b / 100);
                    break;
                default:
                    throw new Error("unknown op");
                }
                stack.push(res);
            }
        }
        if (stack.length !== 1)
            throw new Error("bad result");
        return stack[0];
    }

    property var result: evaluate(expression)

    Component.onCompleted: {
        console.log("[CalcResult] completed. expression:", expression, "result:", JSON.stringify(result));
    }

    Rectangle {
        anchors.fill: parent
        radius: Appearance.rounding.huge
        color: root.transparent ? Qt.alpha(Colors.palette.m3surfaceContainer, root.alpha) : Colors.palette.m3surfaceContainer
        border.width: 1
        border.color: Colors.palette.m3surfaceContainerHigh

        Row {
            id: row
            spacing: Appearance.padding.large
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: Appearance.padding.huge
                rightMargin: Appearance.padding.huge
            }

            property real columnWidth: (width - spacing) / 2

            StyledText {
                width: row.columnWidth
                text: expression
                color: Colors.palette.m3onSurface
                weight: 600
                size: 22
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
            }

            StyledText {
                width: row.columnWidth
                text: result.ok ? result.message : result.message
                color: result.ok ? Colors.palette.m3onSurfaceVariant : Colors.palette.m3error
                weight: 600
                size: 22
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
