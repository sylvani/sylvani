# Sylvani Programming Language

## Discussion (Cantonese)
https://lihkg.com/thread/2392460

## Primitive Types
Void, Num, Str, List, Bool, Dyn etc

## System Functions
while, for, type, print etc

## Reserved Tokens
void, true, false etc

## Syntax

### List Operations
```
List<Num> v = [ 2.0, 1.4 ];
v = v * 2;
print v; # [ 4.0, 2.8 ]
v = v + 1;
print v; # [ 5.0, 3,8 ]
```
> () can be omitted in a function call when there is only one parameter being passed

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

### Function Signature
```
# a function whoes name is "repeat" that takes a string and a number then returns a string
<Str Num -> Str> repeat = (s, n) {
  Str output = "";
  print type output; # Str
  while n > 0 ? {
    n--;
    output += s;
  }
  output;
};

print type repeat; # Str Num -> Str

Str a = repeat("10", 4);
print a; # "10101010"
```
