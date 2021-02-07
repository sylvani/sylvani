#ifndef FUNC_H
#define FUNC_H

#include <iostream>
#include <cstdlib>
#include <string>
#include <cmath>
#include "mem.hpp"

using namespace std;

void debug(double x)
{
  cout << "[DEBUG] Parser: " << x << endl;
}

void yyerror(string msg)
{
  cout << "Failed to parse: " << msg << endl;
}

double eval(int index, string text, int debug = 0)
{
  double val = variable_values[index];
  if (debug == 1)
    cout << "Parser: " << text << " is an ID with value " << val << endl;
  return val;
}
/* Add additional functionality to the calculator besides basic arithmetic */
/* Some of the functionality is already built into C like the trig and logarithmic functions, however conversions and such were not. */

// Convert celsius to fahrenheit
double cel_to_fah(double cel) { return cel * 9 / 5 + 32; }
// Convert fahrenheit to celsius
double fah_to_cel(double fah) { return (fah - 32) * 5 / 9; }

// Convert kilometers to miles
double km_to_m(double km) { return km * 0.62137; }
// Convert miles to kilometers
double m_to_km(double m) { return m / 0.62137; }

// Calculate factorial
double factorial(double n)
{
  double x;
  double f = 1;

  for (x = 1; x <= n; x++)
  {
    f *= x;
  }

  return f;
}

// Calculate modulus
int modulo(double x, double y)
{
  return (int)x % (int)y;
}

#endif