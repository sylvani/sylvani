#ifndef SYLVH
#define SYLVH

#include <map>
#include <list>
#include <vector>
#include <iostream>
#include <algorithm>

using namespace std;

#define ENUM_IDETIFIERS(o) \
  o(undefined)             \
      o(function)          \
          o(parameter)     \
              o(variable)
#define o(n) n,
enum class id_type
{
  ENUM_IDETIFIERS(o)
};
#undef o

struct identifier
{
  id_type type = id_type::undefined;
  size_t index = 0;
  string name;
};

#define ENUM_EXPRESSIONS(o) \
  o(nop) o(string) o(number) o(ident)

#define o(n) n,
enum class ex_type
{
  ENUM_EXPRESSIONS(o)
};
#undef o

typedef list<struct expression> expr_vec;
struct expression
{
  ex_type type;
  identifier ident();
  string strvalue();
  long numvalue = 0;
  expr_vec params;
};

#endif