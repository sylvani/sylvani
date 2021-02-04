const assert = require("assert");
const Environment = require("./Environment");

class Interpreter {
  global;

  constructor(global = new Environment()) {
    this.global = global;
  }

  eval(expr, env = this.global) {
    if (isNum(expr)) {
      return expr;
    }

    if (isStr(expr)) {
      return expr.slice(1, -1);
    }

    if (isOp(expr[0])) {
      const [op, a, b] = expr;
      switch (op) {
        case "+":
          return this.eval(a) + this.eval(b);
        case "-":
          return this.eval(a) - this.eval(b);
        case "*":
          return this.eval(a) * this.eval(b);
        case "/":
          return this.eval(a) / this.eval(b);
        case "%":
          return this.eval(a) % this.eval(b);
      }
    }

    if (expr[0] === "var") {
      const [, id, val] = expr;
      return env.define(id, val);
    }

    if (isId(expr)) {
      return env.lookup(expr);
    }

    throw `Unimplemented: ${JSON.stringify(expr)}`;
  }
}

const OP_ARTM = "+ - * / %".split(" ");
const OP_BTWS = "~ & | ^ << >> ".split(" ");
const OPRTS = OP_ARTM.concat(OP_BTWS);

const isOp = (x) => OPRTS.includes(x);
const isNum = (x) => typeof x === "number";
const isStr = (x) =>
  typeof x === "string" && x[0] === '"' && x.slice(-1) === '"';
const isId = (x) => typeof x === "string" && /^[a-zA-Z_][a-zA-Z0-9_]*$/.test(x);

module.exports = Interpreter;

const test = () => {
  const sylvani = new Interpreter(
    new Environment({
      void: null,
      true: true,
      false: false,
    }),
  );
  assert.strictEqual(sylvani.eval(1), 1);
  assert.strictEqual(sylvani.eval('"i am a str"'), "i am a str");
  assert.strictEqual(sylvani.eval(["+", 16, 4]), 20);
  assert.strictEqual(sylvani.eval(["%", 255, 12]), 3);
  assert.strictEqual(sylvani.eval(["-", ["*", 2, 7], 5]), 9);
  assert.strictEqual(sylvani.eval(["/", ["+", 1, 3], 2]), 2);
  assert.strictEqual(sylvani.eval(["var", "x", 16]), 16);
  assert.strictEqual(sylvani.eval("x"), 16);
  assert.strictEqual(sylvani.eval("void"), null);

  console.log("All assertions passed");
};

test();
