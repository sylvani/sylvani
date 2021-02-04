const Parser = require("../src/parser/Parser");

const parser = new Parser();

const program = `255`;

const ast = parser.parse(program);

console.log(JSON.stringify(ast, null, 2));
