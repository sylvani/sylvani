%defines

%{
  
#include <iostream>
#include <cmath>

// This will be generated using flex from sylvani.l
extern int yylex();
extern void yyerror(char const* msg);
  
%}

%union {
  double dbl;
};

%token<dbl> LITR_DBL

%type<dbl> expr
%type<dbl> term

%start program

%%

/* Grammar Rules */

program: /* empty */
  | program expr '\n'       { std::cout << $2 << std::endl; }
  ;

expr: term                  { $$ = $1; }
  | expr '+' term           { $$ = $1 + $3; }
  | expr '-' term           { $$ = $1 - $3; }
  ;

term: LITR_DBL              { $$ = $1; }
  | term '*' LITR_DBL       { $$ = $1 * $3; }
  | term '/' LITR_DBL       { $$ = $1 / $3; }
  ;

%%

void yyerror(char const* msg) {
  std::cout << "Syntax Error: " << msg << std::endl;
}