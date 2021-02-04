const assert = require("assert");

const Environment = require("../src/Environment");
const Interpreter = require("../src/Interpreter");

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
assert.strictEqual(sylvani.eval(["var", "x", 4]), 4);
assert.strictEqual(sylvani.eval("x"), 4);
assert.strictEqual(sylvani.eval(["var", "y", ["**", "x", 2]]), 16);
assert.strictEqual(sylvani.eval("y"), 16);
assert.strictEqual(sylvani.eval(["set", "y", ["**", "y", 1 / 2]]), 4);
assert.strictEqual(sylvani.eval(["var", "z", "y"]), 4);
assert.strictEqual(sylvani.eval("z"), 4);
assert.strictEqual(sylvani.eval(["-", "z", "y"]), 0);
assert.strictEqual(sylvani.eval(["var", "isOpen", "true"]), true);
assert.strictEqual(sylvani.eval("void"), null);

console.log("All assertions passed");
