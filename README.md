# Sylvani Programming Language

A Symbolic Language

## Motivation

### Pain points in common languages

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
while isTooBig(length(carrot)) { carrot = chop(carrot); };

Str carrot = "<===========================o*";
Fn chop = (Str vege):Str vege[ length(vege) / 2 : ];
Fn isTooBig = (Num size):Bool size > 4;
```

## Classes

```
class Song {
  _init = (Str name, Str artist, Num price): Void {};
};
```

## Strings

```
Str cat = "meow";
cat *= 2; # "meowmeow" ( equivalent to: cat = cat + cat; )
Str[] phonemes = cat / 4; # ["me", "ow", "me", "ow"]
```

## Primitive Types {pm_type}

```
Fn | Void | Num | Str | Bool
```

### Sets

Sets are list without duplicated elements

```
List<Str> BoardMembers = ["Fiona", "Cindy"];
List<Str> Directors = ["Ada", "Thomas", "Fiona"];
List<Str> Teachers = ["Jenny", "Ada", "Tracy", "Thomas"];
List<Str> Staff = Teachers uni Directors;

"Cindy" in Staff; # false
"Ada" in Directors int Teachers; # true
BoardMembers int Directors hsn "Thomas"; # true
```

## Numbers

### Built-in Mathematical Constants

```
0cPI == 3.1415926535...;
0cE == 2.71828...;
```

### Real

`List<Num> real = [ -10, 512, 3.1415926535, 2.71828e+10, 0xE28A, 0cPI, 0cE ];`

### Complex

```
# Converting a complex number into a real number
Com c = 0i, dyn Void ans;

c is Num; # false
print c; # 0i

ans = c ** 2; # 0 * i^2 -> 0 * -1 -> 0
ans is Num; # true
print ans; # 0
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
  Num x = (0cPI ** 2) / 3;
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
print prices["no such item"]; # void
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
error = {
  data = fetch("");
};

print error; # "Error: invalid URL"

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
if, return, yield, stop, exit, try, catch, throw, until, is,
while, type, print, import, export, from, assert
```

> NOTE: there is no else statment, use `? ... : ...` instead of `if ... else ...`

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
  List<Num> v;
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
Num[] evens = until i == 10 { i += 2; };
# evens == [2, ]
```

> NOTE: there is no for loop

## Anonymous Function

`(Num, Str) -> Num> (a, b) { ... }`

## Built-in Values

`void, true, false, error` etc

## Built-in Functions

### List Helpers

`push(), pop(), each(), split(), list(), zeros(), shape(), length(), range()` etc

#### range

`Num? == Num | Void; # true`

```
(Num, Num?, Num?) -> List<Num> range = (start, end = 0, step = 1) {
  List<Num> output = [];

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
<Num -> Void> print_num = (n) { print n; };

each([0.1, 0.04, 0.25, 0.2], print_num);
each(range(2, 10, 2), print_num); # 2 4 6 8
```

### Maths

`sin(), cos(), tan(), log(), ln()` etc

### Others

`str(), map(), num(), error()` etc

## Lists

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

### Modifiers

- Constant modifier: `const Num MAX_SIZE;`
- dynamic type modifier: `dyn Void result;`

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
<Bool, Bool, Bool, Num -> Num> rand_string = (u, l, n, str_len) {
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
# a function whoes name is "repeat" that takes a string and a number then returns a string
<Str, Num -> Str> repeat = (s, n) {
  Str output = "";
  print type output; # Str
  while n > 0 {
    n--;
    output += s;
  };
  output;
};

print type repeat; # <Str, Num -> Str>

Str a = repeat("10", 4);
print a; # "10101010"
```

## Syntax

### List Operations

```
List<Num> v = [ 2.0, 1.4 ];
v = v * 2;
print v; # [ 4.0, 2.8 ]
v = v + 1;
print v; # [ 5.0, 3,8 ]
```

### void

```
<Void -> Void> test = () {
  Num a = 255;
  Num b = a * 4;
  print b / 2;
  void; # the last variable appeared inside {} will be assigned
};
void _ = test(); # 510
print type _; # void
```

### Left to Right Assignment Using "->"

```
List<List<Num>> m;
List<Num> v1, v2, v3, v4;

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
print length(m); # 4

m = [];
print length(m); # 0
```

## Acknowledgements

Symbolic Programming Paradigm
https://www.youtube.com/watch?v=NwckY6o_cNY

Easy Computer Engineering
https://www.youtube.com/watch?v=BocfpYSGYNE
