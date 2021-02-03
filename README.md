# Sylvani Programming Language

## Primitive Types PM_TYPE
```
Void, Dyn<Void [| Num | Str | ...]>, Com, Num, Str, List<Dyn [| Num | Str | ...]>,

Bool, Dyn -> Void, Map<Str, Num | Com> etc
```

``` type Dyn; # PM_TYPE ```

### Dynamic Type
``` Dyn<T> == Dyn | T ```
```
Dyn<Void> result;
type result; # Dyn<Void>
print result; # void

result = 4;
type result; # Dyn<Num>
result is Num; # true
result is Dyn; # true

result = str(result);
type result; # Dyn<Str>
result is Num; # false
result is Dyn; # true
```

## Numbers
```
RTL_ASNG_STMT <- PM_TYPE ( '<' PM_TYPE '>' )? PROP_NAME '=' EXPR ';'
PROP_NAME <- [a-zA-Z0-9_]+
```

### Built-in Mathematical Constants
``` MAT_CST <- '0c' [A-Z]+ ```
```
0cPI == 3.1415926535...;
0cE == 2.71828...;
```

### Real
``` List<Num> real = [ -10, 512, 3.1415926535, 2.71828e+10, 0xE28A, 0cPI, 0cE ]; ```

``` NUM <- [0-9]+ ('.' [0-9]+)? ('e' ('+'|'-') [0-9]+)? | MAT_CST | HEX_NUM ```

### Complex
``` COM_NUM <- NUM 'i' ```
```
# Converting a complex number into a real number
Com c = 0i, Dyn<Void> ans;

c is Num; # false
print c; # 0i

ans = c ** 2; # 0 * i^2 -> 0 * -1 -> 0
ans is Num; # true
print ans; # 0
```

## Group Statement
``` GP_STMT <- '{' (STMT | GP_STMT)* '}' ';' ```
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

## Function Chaining
```
print {
  Dyn _;

  f(_) -> _; g(_) -> _; p(_) -> _; q(_) -> _; r(_) -> _;
  
  yield _;
};
```

## Statement Keywords
```
jump, yield, stop, exit, try, catch, throw, until, is,
while, type, print, import, export, from, assert
```
> NOTE: if and else statement are replaced by ? and : respectively

### jump
Stop evaluating the local group, jump out to the parent group, and yield as if done in the parent group
```
{
  List<Num> v;
  Num index, count = 0;

  v = ...; # very large list of numbers
  
  ...;

  { # how many 255s are in v?
    index = 255 in v;
    
    index > -1 ? { count++; v = v[:index] + v[index:]; }
    
    count > 9999 ? jump -1;

    print index;
  } while index > -1; # if jumped, the yield statement will go here
  
  yield count;
};
```

### stop
Equivalent to ``` yield void; ```

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

### jump
```
```

## Loops

### until
```
Num i = 0; {
  print i;
  i++;
} until i == 100;
```

> NOTE: there is no for loop

## Anonymous Function
``` (Num, Str) -> Num> (a, b) { ... } ```

## Built-in Values
``` void, true, false ``` etc

## Built-in Functions

### List Helpers
``` push(), pop(), each(), split(), list(), zeros(), shape(), length(), range() ``` etc

#### range
``` Num? == Num | Void == true ```
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
``` sin(), cos(), tan(), log(), ln() ``` etc

### Others
``` str(), set(), map(), num(), error() ``` etc

## Operators

### Arithmetic
``` ->, =, +, -, *, **, /, %, ++, -- ```

### Comparison / Relational
``` ==, !=, >, <, >=, <=, <=> ```

### Logical
``` !, &&, || ```

### Bitwise
``` ~, &, |, ^, <<, >> ```

### Others
- Function call: ``` f(); ```
- Keywords: ``` in, of ```
- Conditional: ``` a ? { ... }; ```
- Ternary conditional: ``` a ? b : c; ```
- Constant: ``` const Num MAX_SIZE; ```

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
``` f"Time remaining: {value} second(s)" ```

### Regular Expression
``` r"\w+"ig ```

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

Str token = c"rand_str -u -n 32"; # instead of rand_str(true, false, true, 32);
```
  
## Scope
```
Num width, height = 500, area;
print f"width is a {type width} with value {width}"; # width is a Num with value

# Everything within a process block (PROC) {} has local scope
{
  Num width = 120;
  height = 5 * width; # width has local reference while height has reference outside the local scope
  width * height; # process being resolved to a number
} -> area;
```
  
## Function Type

### Syntax

#### Signature
``` FN_TYPE: '<' PM_TYPE[, PM_TYPE]+ -> PM_TYPE '>' ```

#### Function Body
``` FN_BODY: '(' PARAMS ')' '{' (STMT | EXPR | PROC | FN_BODY)* '}' ```

### Examples
```
# Without function body
<Num, Bool -> Void> functionName;

# A function that does nothing;
<Void -> Void> _ = () {};
_(); # nothing happened
```

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

