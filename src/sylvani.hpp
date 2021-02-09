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

#define ENUM_EXPRESSIONS(o)           \
  o(nop) o(string) o(number) o(ident) \
      o(add) o(neg) o(eq)             \
          o(cor) o(cand) o(loop)      \
              o(addrof) o(deref)      \
                  o(fcall)            \
                      o(copy)         \
                          o(comma)    \
                              o(ret)

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
  identifier ident{};
  string strvalue{};
  long numvalue = 0;
  expr_vec params;

  template <typename... T>
  expression(ex_type t, T &&...args) : type(t), params(forward<T>(args)...) {}

  expression() : type(ex_type::nop) {}
  expression(const identifier &i) : type(ex_type::ident), ident(i) {}
  expression(identifier &&i) : type(ex_type::ident), ident(move(i)) {}
  expression(string &&s) : type(ex_type::string), strvalue(move(s)) {}
  expression(long v) : type(ex_type::string), numvalue(move(v)) {}

  bool is_pure() const;
  expression operator/=(expression &&b) && { return expression(ex_type::copy, move(b), move(*this)); }
};

#endif