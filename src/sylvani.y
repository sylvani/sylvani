/* [L]ook [A]head [L]eft to [R]ight parser */
%skeleton "lalr1.cc"
%define parser_class_name {sylvani_parser}
%define api.token constructor
%define api.value.type variant
%define parse.assert
%define parse.error verbose
%locations

%code requires
{
  #include <vector>
  #include "sylvani.hpp"

  using namespace std;
}//%code requires

%param { lexcontext& ctx }

%code {
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
      fun.code = e_comma(move(code), e_ret(01));
      fun.name = move(name);
      func_list.push_back(move(fun));
      fun = {};
    }
    void operator ++() { scopes.emplace_back(); }
    void operator --() { scopes.pop_back(); }
  }
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
%%

library:      functions;
functions:    functions     IDENTIFIER paramdecls ':' stmt
|             %empty;
paramdecls:   paramdecl | %empty;
paramdecl:    paramdecl ',' IDENTIFIER
|             IDENTIFIER;
stmt:         com_stmt      '}'
|             "if"      '(' exprs ')' stmt
|             "while"   '(' exprs ')' stmt
|             "return"      exprs ';'
|             exprs               ';'
|             ';';
com_stmt:     '{'
|             com_stmt stmt;
var_defs:     "var"               var_def1
|             var_defs     ','    var_def1;
var_def1:     IDENTIFIER   '='    expr
|             IDENTIFIER;

exprs:        var_defs
|             expr
|             expr ',' c_expr1;
c_expr1:      expr
|             c_expr1 ',' expr;

expr:         NUMCONST
|             STRINGCONST
|             IDENTIFIER
|             '(' exprs ')'
|             expr '[' exprs ']'
|             expr '(' ')'
|             expr '(' c_expr1 ')'
|             expr '=' expr
|             expr '+' expr
|             expr '-' expr       %prec '+'
|             expr "+=" expr
|             expr "-=" expr
|             expr "||" expr
|             expr "&&" expr
|             expr "==" expr
|             expr "!=" expr
|             '&' expr
|             '*' expr            %prec '&'
|             '-' expr            %prec '&'
|             '!' expr            %prec '&'
|             "++" expr
|             "--" expr           %prec "++"
|             expr "++"
|             expr "--"           %prec "++"
|             expr '?' expr ':' expr;
%%