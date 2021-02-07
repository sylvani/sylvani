%defines

%union {
  int index;
  double num;
}

%token<num> PRINT
%token<num> NUMBER
%token<num> L_BRC R_BRC
%token<num> L_PRT R_PRT
%token<num> L_SQR R_SQR
%token<num> DOT QMARK COLON COMMA
%token<num> B_COM B_AND B_OR B_XOR B_LSH B_RSH
%token<num> DIV MUL ADD SUB EQ
%token<num> PI EULER
%token<num> POW SQRT FACTORIAL MOD
%token<num> LOG2 LOG10
%token<num> FLOOR CEIL ABS
%token<num> COS SIN TAN COSH SINH TANH
%token<num> CEL_TO_FAH FAH_TO_CEL
%token<num> M_TO_KM KM_TO_M
%token<num> ID_TYPE 
%token<index> ID
%token<num> EOS

%type<num> program
%type<num> stmt
%type<num> constant
%type<num> expr
%type<num> function
%type<num> assignment

/* Set operator precedence, follows BODMAS rules. */
%left SUB 
%left ADD
%left MUL 
%left DIV 
%left POW SQRT 
%left L_BRC R_BRC

%start program

%{

#pragma warning(disable 4996)
  
#include <iostream>
#include <cstdlib>
#include <string>
#include <cmath>
#include "utils.hpp"

using namespace std;

/* Used for variable stores. Defined in mem.hpp */
extern int set_variable(int index, double val);
extern int variable_set[100];
extern double variable_values[100];

/* Flex functions */
extern char *yytext;
extern int yylex(void);
extern void yyterminate();
extern FILE* yyin;
  
%}

%%
  
program: /* empty */
  | stmt
  | program stmt            { debug($$); }
  | program EOS             { cout << "Parser: empty program" << endl; }
  ;

stmt: /* empty */
  | expr EOS
  | assignment EOS
  ;
  
assignment: /* empty */
  | declration EQ expr
  | ID EQ expr              { $$ = set_variable($1, $3); }
  ;
  
declration: /* empty */
  | ID_TYPE ID;
  ;
  
expr: /* empty */
  | constant  
  | function
  | ID                      { $$ = eval($1, yytext); }
  | NUMBER                  { $$ = $1; debug($$); }
  | SUB expr                { $$ = -$2; }
  | L_BRC expr R_BRC        { $$ = $2; }
  | expr NUMBER             { $$ = $1 + $2; }
  | expr MUL expr           { $$ = $1 * $3; }
  | expr ADD expr           { $$ = $1 + $3; }
  | expr SUB expr           { $$ = $1 - $3; }
  | expr POW expr           { $$ = pow($1, $3); }
  | expr MOD expr           { $$ = modulo($1, $3); }
  | expr DIV expr           {
                              if ($3 == 0) {
                                yyerror("Cannot divide by zero");
                                exit(10);
                              }
                              else $$ = $1 / $3;
                            }
  ;
  
constant: /* empty */
  | PI                      { $$ = 3.1415926535; }
  | EULER                   { $$ = 2.718281828459045; }
  ;
  
function: /* empty */
  | PRINT expr              { cout << $2 << endl; }
  | SQRT expr               { $$ = sqrt($2); }
  | FACTORIAL expr          { $$ = factorial($1); }
  | ABS expr                { $$ = abs($2); }
  | FLOOR expr              { $$ = floor($2); }
  | CEIL expr               { $$ = ceil($2); }
  ;
%%