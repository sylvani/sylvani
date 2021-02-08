<p align="center">
  <img src="https://avatars.githubusercontent.com/u/78455784?s=200" />
</p>

# Sylvani Programming Language

A Symbolic Language

## Installation

Before installing, make sure you have these development tools:

```
g++, flex, bison
```

To install, run the following

```
git clone https://github.com/sylvani/sylvani.git
```

```
cd sylvani
```

```
make
```

## Motivation

Programming languages are usually created to solve certain problems,
and the importance of syntax is often overlooked.

Yet it is very hard to define what it means by good syntax.
In my opinion, a good syntax helps us understand the code better
and express ideas easier using the code.

### Pain points in common languages

[TODO]

## Use first, define later

Expressing ideas in mathematicians tradition

```
# Electric force between two charges

Num F = k * q1 * q2 / { r ** 2 };

# Where
Num k = 9e+9;
Num q1 = ...;
Num q2 = ...;
Num r = ...;

print F;
```

![Coulomb's Law](https://na.cx/i/9MwZjKR.jpg "Coulomb's Law")

#### Image credit

https://lpilen23.wordpress.com/2017/12/06/the-coulombs-law/

```
while isTooBig(leng(carrot)) { carrot = chop(carrot); };

Str carrot = "<===========================o*";
Fn chop = (Str vege):Str vege[ leng(vege) / 2 : ];
Fn isTooBig = (Num size):Bool size > 4;
```

## Classes

```
class Song {
  init = (Str name, Str artist, Num price) {
    this.name = name;
  };
};
```

[TODO]

## Strings

```
Str cat = "meow";
cat *= 2; # "meowmeow" ( equivalent to: cat = cat + cat; )
Str[] phonemes = cat / 4; # ["me", "ow", "me", "ow"]
```

## Primitive Types {id_type}

`Fn | Void | Num | Str | Bool`

```
Num a, b = 16;

Num[] ls = [a, b];
```

### Sets

Sets are list without duplicated elements

```
Str[] BoardMembers = ["Fiona", "Cindy"];
Str[] Directors = ["Ada", "Thomas", "Fiona"];
Str[] Teachers = ["Jenny", "Ada", "Tracy", "Thomas"];
Str[] Staff = Teachers uni Directors;

"Cindy" in Staff; # false
"Ada" in { Directors int Teachers }; # true
{ BoardMembers int Directors } hsn "Thomas"; # true
```

## Numbers

### Built-in Mathematical Constants

```
0cPI == 3.1415926535...;
0cE == 2.71828...;
```

### Real

`Num[] real = [ -10, 512, 3.1415926535, 2.71828e+10, 0xE28A, 0cPi, 0cE ];`

### Complex

```
0i == 0;

1i * 1i == -1;

2 * 3i == 6i;
```

```
Num c = 2 + 5i;

c * c == { 2 + 5i } * { 2 + 5i }
== 4 + 4 * 5i - 25
== -21 + 20i;
```

## Group Statement

Everything inside {} is reduced to a final value

```
Num ans = 0;

{ # group 1
  Num x = 4;
  Num y = x ** 2;
  ans += y;
};

{ # group 2
  Num x = { 0cPI ** 2 } / 3;
  Num y = cos(x) / x;
  ans += y;
};

print ans;
```

## Lists

### Named Indexing

```
Num[] evens = [2, 4, 6, 8];

# Equivalent to
Num[Num] evens = [ 0: 2, 1: 4, 2: 6, 3: 8 ];

# String as index
Num[Str] prices = [ "banana": 2.5, "orange": 4.99 ];

print prices["orange"]; # 4.99
print prices["no such item"] is Void; # true
```

### Nested Lists

```
Num[][] m = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
];
```

## Error Handling

```
# error is a built-in value: Void error = void;
error = {
  data = fetch("");
  void; # if the code reaches here, set error to void
};

if error != void print error; # "Error: invalid URL"

Fn fetch = (Str url): Data {
  if url == ""
    throw "Error: invalid URL";

  Response res = sendRequest(url);
  ...

  return Data([ "name": res.name, ]);
};
```

## Function Chaining

The chain `f, g, p, q, r` is clearly shown thanks to left-to-right assignment "->"

```
print {
  Num _ = 0;

  f(_) -> _;
  g(_) -> _;
  p(_) -> _;
  q(_) -> _;
  r(_) -> _;

  yield _;
};
```

## Statement Keywords

```
if, else, return, yield, stop, exit, try, catch, throw, until, is,
while, typeof, print, import, export, from, assert
```

### return

Carry a final value then jump out of nested group
until finding an assignment operator
or reaching the outermost group

```
Num a = {
  Num c;
  Num b = {
    c = {
      return 2 * 7; # resolve to c
    };
    return c - 1; # resolve to b
  };

  c - b > 0 ? {
    ...;
    {
      ...;
      {
        return 0; # resolve to a, skipping all parent groups
      }
    }
  };

  return c - b;
};
```

```
print {
  Num[] v;
  Num index, count = 0;

  v = ...; # very large list of numbers

  ...;

  { # how many 255s are in v?
    index = 255 in v;

    index > -1 ? { count++; v = v[:index] + v[index:]; }

    count > 9999 ? return -1;

    print index;
  } while index > -1;

  return count;
};
```

### stop

Equivalent to `yield void;`

### yield

Stop a group statement by yielding a final result

```
Bool isOpen = false;

...

print {
  isOpen ? close(), yield "it has been closed"; # the statement below won't be evaluated

  open(), yeild "now it is open";
};
```

## Conditional Statements

### if

```
if true {};
{} if true;
```

### while

```
while true {};
# or
{} while true;
```

### until

```
Num i = 0;
Num[] evens = { i += 2 } until i == 10;
# evens == [2, 4, 6, 8, 10]
```

> NOTE: there is no for loop

## Anonymous Function

`(Num a, Str b): Num { ... };`

## Built-in Values

`void, true, false, error` etc

## Built-in Functions

### List Helpers

`push(), pop(), each(), split(), list(), zeros(), shape(), leng(), range()` etc

```
Fn leng = (Void[] x): Num {
  Num i = 0;
  { i++ } until x[i] is Void;
  return i;
};
```

#### range

```
Fn range = (Num start, Num end = 0, Num step = 1) {
  Num[] output = [];

  Num i = start;

  {
    output[] = i;
    i += step;
  } until i >= end;

  yield output;
};
```

#### each

```
Fn print_num = (Num n): Void { print n; };

each([0.1, 0.04, 0.25, 0.2], print_num);
each(range(2, 10, 2), print_num); # 2 4 6 8
```

### Maths

`sin(), cos(), tan(), log(), ln()` etc

### Others

`str(), map(), num(), error()` etc

### Operators

```
com A; # complement
A int B; # intersection
A uni B; # union
A dif B; # symmetric difference: { A - B }
A - B;
A * B;
```

### Relations

```
x in B;
x ni B;
A has y;
A hsn y;
A == B;
A sub B;
A sup B;
A nsub B;
A nsup B;
```

## Operators

### Arithmetic

`->, =, +, -, *, **, /, %, ++, --`

### Comparison / Relational

`==, !=, >, <, >=, <=, <=>`

### Logical

`!, &&, ||`

### Bitwise

`~, &, |, ^, <<, >>`

### Others

- Function call: `f();`
- Keywords: `in, of`

> UPDATE: Ternary conditional operators `?` and `:` removed

## Strings

### Inline String

"I am a string";

### Block String

```
`
  I am a block string
  I love Sylvani
`;
```

### Formatted String

`f"Time remaining: {value} second(s)"`

### Regular Expression

`r"\w+"ig`

### Command Line Style Function Call

```
Fn rand_string = (Bool u, Bool l, Bool n, Num str_len): Num {
  Str output = "";

  while str_len > 0 {
    str_len--;
    output += rand_char();
  }

  u ? doA : l ? doB : doC;
  n ? doD;

  output;
};

Str key = c"rand_str -u -n 32"; # instead of rand_str(true, false, true, 32);
```

## Scope

```
Num width, height = 500, area;
print width; # 500;

# Everything within a grp_stmt has local scope
{
  Num width = 120;
  print width; # 120;
  print height; # 500;

  # width has local reference while height has reference outside the local scope

  width * height; # statement group being resolved to a number
} -> area;
```

## Functions

```
# Declaration
Fn functionName;

# Definition
Fn f = () {};
f(); # nothing happened
```

`Fn sum = (Num a, Num b) a + b;`

```
# a function whoes name is "repeat"
# that takes a string and a number then returns a string

Fn repeat = (Str s, Num n): Str {
  Str output = "";
  print typeof output; # Str
  while n > 0 {
    n--;
    output += s;
  };
  output;
};

print typeof repeat; # Fn: Str, Num -> Str

Str a = repeat("10", 4);
print a; # "10101010"
```

## Syntax

### List Operations

```
Num[] v = [ 2.0, 1.4 ];
v = v * 2;
print v; # [ 4.0, 2.8 ]
v = v + 1;
print v; # [ 5.0, 3,8 ]
```

### void

```
Fn test = (): Void {
  Num a = 255;
  Num b = a * 4;
  print b / 2;
  void; # the last variable appeared inside {} will be assigned
};
void _ = test(); # 510
print typeof _; # void
```

### Left to Right Assignment Using "->"

```
Num[][] m;
Num[] v1, v2, v3, v4;

{
  zeros 4 -> v1; # [ 0, 0, 0, 0 ]
  v1 + 1 -> v2; # [ 1, 1, 1, 1 ]
  v3 = v1 - v2; # [ -1, -1, -1, -1 ]
  v3 / 2;
} -> v4; # [ -0.5, -0.5, -0.5, -0.5 ]

m[] = v1; # m[0] == [ 0, 0, 0, 0 ]
m[] = v2; # m == [ [ 0, 0, 0, 0, ], [ 1, 1, 1, 1 ] ]
v3 -> m[2]; # m[2] == [ -1, -1, -1, -1 ]
v4 -> m[];
print leng(m); # 4

m = [];
print leng(m); # 0
```

## Acknowledgements

Symbolic Programming Paradigm
https://www.youtube.com/watch?v=NwckY6o_cNY

Easy Computer Engineering
https://www.youtube.com/watch?v=BocfpYSGYNE
