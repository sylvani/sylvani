#ifndef FUNC_H
#define FUNC_H

#include <iostream>
// #include <cstdlib>
#include <cassert>
#include <string>
// #include <cmath>

using namespace std;

template <typename T>
void debug(T x)
{
  cout << "[DEBUG] Parser: " << x << endl;
}

double oprt(char op, double a, double b)
{
  switch (op)
  {
  case '+':
    return a + b;
  case '-':
    return a - b;
  case '*':
    return a * b;
  }

  if (op == '/' || op == '%')
  {

    assert(b != 0.0);

    if (op == '%')
      return (int)a %
             (int)b;

    return a / b;
  }
  assert(false);
}

#endif