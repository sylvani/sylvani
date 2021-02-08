#ifndef MEM_H
#define MEM_H

#include <string>
#include <iostream>
#include <map>
#include <cassert>

using namespace std;

enum Type
{
  Fn,
  Void,
  Num,
  Str,
  Bool,
  FnLs,
  NumLs,
  StrLs,
  BoolLs,
};

struct data
{
  Type type;
  // num, numls, str, strls
  double numval;
  string strval;
  string *strlsval;
  double *numlsval;
};

map<string, data> variables;

struct varres
{
  bool found;
  map<string, data>::iterator i;
};

varres vardefined(string name)
{
  map<string, data>::iterator i = variables.find(name);
  bool found = i != variables.end();
  varres res = {
      .found = found,
  };
  if (found)
    res.i = i;
  return res;
}

/* Set a variables value in the memory store */
void setvar(string name, data nval)
{
  varres res = vardefined(name);
  assert(res.found);
  res.i->second = nval;
}

void defvar(string name, data val)
{
  varres res = vardefined(name);
  assert(!res.found);
  variables[name] = val;
}

data getvar(string name)
{
  varres res = vardefined(name);
  assert(res.found);
  return res.i->second;
}

#endif