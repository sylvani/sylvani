# Sylvani Programming Language

## Numbers
-10, 512, 3.1415926535, 2.71828e+10, 0xE28A

## Statement Keywords
if, else, while, for, type, print, import, from etc

## Built-in Values
void, true, false etc

## Built-in Functions
list(), zeros(), string(), shape(), length(), range()

## Operators

### Arithmetic
->, =, +, -, *, /, %, ++, --

### Comparison / Relational
==, !=, >, <, >=, <=, <=>

### Logical
!, &&, ||

### Bitwise
~, &, |, ^, <<, >>

### Others
Function call: f();
Keywords: in, of, stop, exit
Conditional: a ? { ... };
Ternary conditional: a ? b : c;
Constant: const Num MAX_SIZE;

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
f"Time remaining: {value} second(s)"

### Regular Expression
r"\w+"ig

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
Str token = c"rand_string -u -n 32"; # instead of rand_string(true, false, true, 32);
```

## Primitive Types
Void, Num, Str, List, Bool, Dyn, <Dyn -> Void> etc
  
## Function Type

### Syntax

#### Signature
``` FN_TYPE: '<' PM_TYPE[, PM_TYPE]+ -> PM_TYPE '>' ```

#### Function Body
``` FN_BODY: '(' PARAMS ')' '{' (STMT | EXPR | PROC | FN_BODY) '}' ```

### Examples
``` <Num, Bool -> Void> functionName ```

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
print length m; # 4

m = [];
print length m; # 0
```

