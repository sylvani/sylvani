/* [L]ook [A]head [L]eft to [R]ight parser */
%skeleton "lalr1.cc"
%define api.parser.class {sylcc}
%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define parse.error verbose
%locations

%code requires
{

#include <vector>
#include "sylvani.hpp"

}//%code requires

%param { lexcontext& ctx }

%code {

using namespace std;

struct lexcontext {
  vector<map<string, identifier>> scopes;
  vector<function> func_list;
  function fun;
public:
  const identifier& define(const string& name, identifier&& f)
  {
    auto r = scopes.back().emplace(name, move(f));
    return r.first->second;
  }
  expression def(const string& name)        { return define(name, identifier{id_type::variable, fun.num_vars++, name}); }
  expression defun(const string& name)      { return define(name, identifier{id_type::function, func_list.size(), name}); }
  expression defparam(const string& name)   { return define(name, identifier{id_type::parameter, fun.num_params++, name}); }
  expression temp()                         { return def("$i" + to_string(tempcounter++)); }
  expression use(const string& name)
  {
    for (auto j = scopes.crbegin(); j != scopes.crend(); ++j)
      if (auto i = j->find(name); i != j->end())
        return i->second;
  }
  void add_function(string&& name, expression& code)
  {
    fun.code = e_comma(move(code), e_ret(0L));
    fun.name = move(name);
    func_list.push_back(move(fun));
    fun = {};
  }
  void operator ++() { scopes.emplace_back(); }
  void operator --() { scopes.pop_back(); }
}

#define M(x) move(x)
#define C(x) expression(x)

}//%code

%token END 0
%token RETURN "return" WHILE "while" IF "if" VAR "var" IDENTIFIER NUMCONST STRINGCONST
%token OR "||" AND "&&" EQ "==" NE "!=" PP "++" MM "--" PL_EQ "+=" MI_EQ "-="
%left   ','
%right  '?' ':' '=' "-=" "+="
%left   "||"
%left   "&&"
%left   "==" "!="
%left   '+' '-'
%left   '*'
%right  '&' "++" "--"
%left   '(' '['

%type<long>   NUMCONST
%type<string> IDENTIFIER STRINGCONST
%type<expression> expr exprs c_expr1 stmt var_def1 var_defs com_stmt 
%%

library:      { ++ctx; } functions { --ctx; };
functions:    functions IDENTIFIER { ctx.defun($2); ++ctx; } paramdecls ':' stmt { ctx.add_function(M($2), M($6)); --ctx; }
|             %empty;
paramdecls:   paramdecl | %empty;
paramdecl:    paramdecl ',' IDENTIFIER        { ctx.defparam($3); }
|             IDENTIFIER                      { ctx.defparam($1); };
stmt:         com_stmt      '}'               { $$ = M($1); --ctx; }
|             "if"      '(' exprs ')' stmt    { $$ = e_cand(M($3), M($5)); }
|             "while"   '(' exprs ')' stmt    { $$ = e_loop(M($3), M($5)); }
|             "return"      exprs ';'         { $$ = e_ret(M($2)); }
|             exprs               ';'         { $$ = M($1); }
|             ';'                             {};
com_stmt:     '{'                             { $$ = e_comma(); ++ctx; }
|             com_stmt stmt                   { $$ = M($1); $$.params.push_back(M($2)); };
var_defs:     "var"               var_def1    { $$ = e_comma(M($2)); }
|             var_defs     ','    var_def1    { $$ = M($1); $$.params.push_back(M($3)); };
var_def1:     IDENTIFIER   '='    expr        { $$ = ctx.def($1) %= M($3); }
|             IDENTIFIER                      { $$ = ctx.def($1) %= 0L; };

exprs:        var_defs                        { $$ = M($1); }
|             expr                            { $$ = M($1); }
|             expr ',' c_expr1                { $$ = e_comma(M($1)); $$.params.splice($$.params.end(), M($3.params)); };
c_expr1:      expr                            { $$ = e_comma(M($1)); }
|             c_expr1 ',' expr                { $$ = M($1); $$.params.push_back(M($3)); };

expr:         NUMCONST                        { $$ = $1; }
|             STRINGCONST                     { $$ = M($1); }
|             IDENTIFIER                      { $$ = ctx.use($1); }
|             '(' exprs ')'                   { $$ = M($2); }
|             expr '[' exprs ']'              { $$ = e_deref(e_add(M($1), M($3))); }
|             expr '(' ')'                    { $$ = e_fcall(M($1)); }
|             expr '(' c_expr1 ')'            { $$ = e_fcall(M($1)); $$.params.splice($$.params.end(), M($3.params)); }
|             expr '=' expr                   { $$ = M($1) %= M($3); }
|             expr '+' expr                   { $$ = e_add(M($1),M($3)); }
|             expr '-' expr       %prec '+'   { $$ = e_add(M($1),e_neg(M($3))); }
|             expr "+=" expr                  { if(!$3.is_pure()) { $$ = ctx.temp() %= e_addrof(M($1)); $1 = e_deref($$.params.bakc()); }
                                                $$ = e_comma(M($$), M($1) %= e_add(C($1), M($3))); }
|             expr "-=" expr                  { if(!$3.is_pure()) { $$ = ctx.temp() %= e_addrof(M($1)); $1 = e_deref($$.params.bakc()); }
                                                $$ = e_comma(M($$), M($1) %= e_add(C($1), e_neg( M($3) ))); }
|             "++" expr                       { if(!$2.is_pure()) { $$ = ctx.temp() %= e_addrof(M($2)); $2 = e_deref($$.params.bakc()); }
                                                $$ = e_comma(M($$), M($2) %= e_add(C($2), 1L)); }
|             "--" expr           %prec "++"  { if(!$2.is_pure()) { $$ = ctx.temp() %= e_addrof(M($2)); $2 = e_deref($$.params.bakc()); }
                                                $$ = e_comma(M($$), M($2) %= e_add(C($2), -1L)); }
|             expr "++"                       { if(!$1.is_pure()) { $$ = ctx.temp() %= e_addrof(M($1)); $1 = e_deref($$.params.bakc()); }
                                                auto i = ctx.temp(); $$ = e_comma(M($$), C(i) %= C($1), C($1) %= e_add(C($1), 1L), C(i)); }
|             expr "--"           %prec "++"  { if(!$1.is_pure()) { $$ = ctx.temp() %= e_addrof(M($1)); $1 = e_deref($$.params.bakc()); }
                                                auto i = ctx.temp(); $$ = e_comma(M($$), C(i) %= C($1), C($1) %= e_add(C($1), -1L), C(i)); }
|             expr "||" expr                  { $$ = e_cor(M($1), M($3)); }
|             expr "&&" expr                  { $$ = e_cand(M($1), M($3)); }
|             expr "==" expr                  { $$ = e_eq(M($1), M($3)); }
|             expr "!=" expr                  { $$ = e_eq(e_eq(M($1), M($3)), 0L); }
|             '&' expr                        { $$ = e_addrof(M($2)); }
|             '*' expr            %prec '&'   { $$ = e_deref(M($2)); }
|             '-' expr            %prec '&'   { $$ = e_neg(M($2)); }
|             '!' expr            %prec '&'   { $$ = e_eq(M($2), 0L); }
|             expr '?' expr ':' expr          { auto i = ctx.temp();
                                                $$ = e_comma(e_cor(e_cand(M($1), e_comma(C(i) %= M($3), 1L)), C(i) %= M($5)), C(i)); };
%%

bool expression::is_pure() const
{
  for(const auto& e: params) if (!e.is_pure()) return false;
  switch(type)
  {
    case ex_type::fcall: return false;
    case ex_type::copy: return false;
    case ex_type::ret: return false;
    case ex_type::loop: return false;
    default: return true;
  }
}