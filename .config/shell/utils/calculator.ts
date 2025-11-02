enum TokenType {
  NUMBER,
  OPERATOR,
  PAREN_OPEN,
  PAREN_CLOSE,
  FUNCTION,
}

interface Token {
  type: TokenType;
  value: string;
}

const OPERATORS: {
  [key: string]: { precedence: number; associativity: "left" | "right" };
} = {
  "+": { precedence: 1, associativity: "left" },
  "-": { precedence: 1, associativity: "left" },
  "*": { precedence: 2, associativity: "left" },
  "/": { precedence: 2, associativity: "left" },
};

const FUNCTIONS = ["sqrt"];

function tokenize(expression: string): Token[] {
  const tokens: Token[] = [];
  let i = 0;

  while (i < expression.length) {
    let char = expression[i];

    if (/\s/.test(char)) {
      i++;
      continue;
    }

    if (/\d|\./.test(char)) {
      let value = "";
      while (i < expression.length && /\d|\./.test(expression[i])) {
        value += expression[i];
        i++;
      }
      tokens.push({ type: TokenType.NUMBER, value });
      continue;
    }

    if (char === "(") {
      tokens.push({ type: TokenType.PAREN_OPEN, value: char });
      i++;
      continue;
    }

    if (char === ")") {
      tokens.push({ type: TokenType.PAREN_CLOSE, value: char });
      i++;
      continue;
    }

    if (OPERATORS[char]) {
      tokens.push({ type: TokenType.OPERATOR, value: char });
      i++;
      continue;
    }

    let matchedFunction = false;
    for (const func of FUNCTIONS) {
      if (expression.substring(i, i + func.length) === func) {
        tokens.push({ type: TokenType.FUNCTION, value: func });
        i += func.length;
        matchedFunction = true;
        break;
      }
    }
    if (matchedFunction) continue;
    throw new Error(`Invalid character: ${char}`);
  }
  return tokens;
}

function shuntingYard(tokens: Token[]): Token[] {
  const outputQueue: Token[] = [];
  const operatorStack: Token[] = [];

  for (const token of tokens) {
    switch (token.type) {
      case TokenType.NUMBER:
        outputQueue.push(token);
        break;
      case TokenType.FUNCTION:
        operatorStack.push(token);
        break;
      case TokenType.OPERATOR:
        while (
          operatorStack.length > 0 &&
          (operatorStack[operatorStack.length - 1].type ===
            TokenType.OPERATOR ||
            operatorStack[operatorStack.length - 1].type ===
            TokenType.FUNCTION) &&
          OPERATORS[token.value].precedence <=
          OPERATORS[operatorStack[operatorStack.length - 1].value]
            ?.precedence &&
          OPERATORS[token.value].associativity === "left"
        ) {
          outputQueue.push(operatorStack.pop()!);
        }
        operatorStack.push(token);
        break;
      case TokenType.PAREN_OPEN:
        operatorStack.push(token);
        break;
      case TokenType.PAREN_CLOSE:
        while (
          operatorStack.length > 0 &&
          operatorStack[operatorStack.length - 1].type !== TokenType.PAREN_OPEN
        ) {
          outputQueue.push(operatorStack.pop()!);
        }
        if (
          operatorStack.length === 0 ||
          operatorStack[operatorStack.length - 1].type !== TokenType.PAREN_OPEN
        ) {
          throw new Error("Mismatched parentheses");
        }
        operatorStack.pop(); // Pop the open parenthesis
        if (
          operatorStack.length > 0 &&
          operatorStack[operatorStack.length - 1].type === TokenType.FUNCTION
        ) {
          outputQueue.push(operatorStack.pop()!);
        }
        break;
    }
  }

  while (operatorStack.length > 0) {
    const op = operatorStack.pop()!;
    if (op.type === TokenType.PAREN_OPEN || op.type === TokenType.PAREN_CLOSE) {
      throw new Error("Mismatched parentheses");
    }
    outputQueue.push(op);
  }

  return outputQueue;
}

function evaluateRPN(rpnTokens: Token[]): number {
  const stack: number[] = [];

  for (const token of rpnTokens) {
    switch (token.type) {
      case TokenType.NUMBER:
        stack.push(parseFloat(token.value));
        break;
      case TokenType.OPERATOR:
        if (stack.length < 2) {
          throw new Error(
            "Invalid expression: not enough operands for operator"
          );
        }
        const operand2 = stack.pop()!;
        const operand1 = stack.pop()!;
        switch (token.value) {
          case "+":
            stack.push(operand1 + operand2);
            break;
          case "-":
            stack.push(operand1 - operand2);
            break;
          case "*":
            stack.push(operand1 * operand2);
            break;
          case "/":
            if (operand2 === 0) throw new Error("Division by zero");
            stack.push(operand1 / operand2);
            break;
          default:
            throw new Error(`Unknown operator: ${token.value}`);
        }
        break;
      case TokenType.FUNCTION:
        if (stack.length < 1) {
          throw new Error(
            "Invalid expression: not enough operands for function"
          );
        }
        const arg = stack.pop()!;
        switch (token.value) {
          case "sqrt":
            if (arg < 0)
              throw new Error("Cannot take square root of a negative number");
            stack.push(Math.sqrt(arg));
            break;
          default:
            throw new Error(`Unknown function: ${token.value}`);
        }
        break;
      default:
        // Should not happen with correct tokenization and shunting-yard
        throw new Error(`Unexpected token type in RPN: ${token.type}`);
    }
  }

  if (stack.length !== 1) {
    throw new Error("Invalid expression: too many operands or operators");
  }

  return stack.pop()!;
}

export function evaluateExpression(expression: string): number {
  const tokens = tokenize(expression);
  const rpnTokens = shuntingYard(tokens);
  const result = evaluateRPN(rpnTokens);
  return result;
}
