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
  #include "sylvani.hpp"
} // %code requires

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