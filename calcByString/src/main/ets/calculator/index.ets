import {Operator} from './types'

const applyOperator = (a: number, b: number, op: Operator): number => {
  switch (op) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      return a / b;
    default:
      throw new Error(`Unknown operator: ${op}`);
  }
};

export function calculateByString(expression: string): number {
  const numbers: number[] = [];
  const operators: Operator[] = [];
  const precedence: Record<string, number> = { '+': 1, '-': 1, '*': 2, '/': 2 };

  const parse = (expr: string): void => {
    let numBuffer: string = '';
    for (const char of expr) {
      if (char === ' ') continue;
      if ('0' <= char && char <= '9' || char === '.') {
        numBuffer += char;
      } else {
        if (numBuffer !== '') {
          numbers.push(parseFloat(numBuffer));
          numBuffer = '';
        }
        if (char === '(') operators.push(char);
        else if (char === ')') {
          while (operators[operators.length - 1] !== '(') {
            const op = operators.pop() !;
            const b = numbers.pop() !;
            const a = numbers.pop() !;
            numbers.push(applyOperator(a, b, op));
          }
          operators.pop();
        } else if ('+-*/'.includes(char)) {
          while (operators.length && precedence[operators[operators.length - 1]] >= precedence[char]) {
            const op = operators.pop() !;
            const b = numbers.pop() !;
            const a = numbers.pop() !;
            numbers.push(applyOperator(a, b, op));
          }
          operators.push(char as Operator);
        }
      }
    }
    if (numBuffer !== '') {
      numbers.push(parseFloat(numBuffer));
    }
  };

  parse(expression);

  while (operators.length) {
    const op = operators.pop() !;
    const b = numbers.pop() !;
    const a = numbers.pop() !;
    numbers.push(applyOperator(a, b, op));
  }

  if (numbers.length !== 1) {
    throw new Error('Invalid expression');
  }

  return numbers[0];
}