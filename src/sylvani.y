%defines

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
extern int yylex(void);
extern void yyterminate();
void yyerror(string msg);
extern FILE* yyin;
  
%}

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
%type<num> log_function
%type<num> trig_function
%type<num> hyperbolic_function
%type<num> assignment
%type<num> conversion
%type<num> temperature_conversion
%type<num> distance_conversion

/* Set operator precedence, follows BODMAS rules. */
%left SUB 
%left ADD
%left MUL 
%left DIV 
%left POW SQRT 
%left L_BRC R_BRC

%%
  
program: /* empty */
  | program stmt EOS                { cout << $2 << endl; };
  ;

stmt: expr EOS
  | function EOS
  | assignment EOS
  ;
  
expr: SUB expr              { $$ = -$2; }
  | NUMBER                  { $$ = $1; }
  | ID                      { $$ = variable_values[$1]; }
  | constant  
  | function
  | expr DIV expr           {
                              if ($3 == 0) {
                                yyerror("Cannot divide by zero");
                                exit(10);
                              }
                              else $$ = $1 / $3;
                            }
  | expr MUL expr           { $$ = $1 * $3; }
  | L_BRC expr R_BRC        { $$ = $2; }
  | expr ADD expr           { $$ = $1 + $3; }
  | expr SUB expr           { $$ = $1 - $3; }
  | expr POW expr           { $$ = pow($1, $3); }
  | expr MOD expr           { $$ = modulo($1, $3); }
  ;
  
constant: /* empty */
  | PI                      { $$ = 3.1415926535; }
  | EULER                   { $$ = 2.718281828459045; }
  ;
  
function: /* empty */
  | conversion
  | log_function
  | trig_function
  | hyperbolic_function
  | PRINT expr              { cout << $2 << endl; }
  | SQRT expr               { $$ = sqrt($2); }
  | FACTORIAL expr          { $$ = factorial($1); }
  | ABS expr                { $$ = abs($2); }
  | FLOOR expr              { $$ = floor($2); }
  | CEIL expr               { $$ = ceil($2); }
  ;

trig_function: /* empty */
  | COS expr                { $$ = cos($2); }
  | SIN expr                { $$ = sin($2); }
  | TAN expr                { $$ = tan($2); }
  ;
  
log_function: /* empty */
  | LOG2 expr               { $$ = log2($2); }
  | LOG10 expr              { $$ = log10($2); }
  ;
  
hyperbolic_function: /* empty */
  | COSH expr               { $$ = cosh($2); }
  | SINH expr               { $$ = sinh($2); }
  | TANH expr               { $$ = tanh($2); }
  ;
  
conversion: /* empty */
  | temperature_conversion
  | distance_conversion
  ;

temperature_conversion: /* empty */
  | expr CEL_TO_FAH         { $$ = cel_to_fah($1); }
  | expr FAH_TO_CEL         { $$ = fah_to_cel($1); }
  ;

distance_conversion: /* empty */
  | expr M_TO_KM            { $$ = m_to_km($1); }
  | expr KM_TO_M            { $$ = km_to_m($1); }
  ;
  
assignment: /* empty */
  | ID_TYPE ID EQ stmt      { $$ = set_variable($2, $4); }
  ;
%%

void yyerror(string msg) {
  cout << "Failed to parse: " << msg << endl;
}