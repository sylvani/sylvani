%{
#pragma warning(disable 4996)
  
#include <iostream>
#include <cstdlib>
#include <string>
#include <cmath>
#include "utils.hpp"

using namespace std;

/* Flex functions */
extern FILE* yyin;
extern char *yytext;
extern int yylex(void);
extern void yyterminate();

void yyerror(string msg)
{
  cout << "Failed to parse: " << msg << endl;
}
%}

%defines

%union {
  double num;
}

%token<num> ID

%token<num> PRINT
%token<num> L_BRC R_BRC
%token<num> L_PRT R_PRT
%token<num> L_SQR R_SQR
%token<num> DOT QMARK COLON COMMA
%token<num> B_COM B_AND B_OR B_XOR B_LSH B_RSH
%token<num> POW MOD DIV MUL ADD SUB EQ
%token<num> MUL_EQ ADD_EQ SUB_EQ POW_EQ MOD_EQ DIV_EQ
%token<num> B_AND_EQ B_OR_EQ B_XOR_EQ B_LSH_EQ B_RSH_EQ

%token<num> ID_TYPE 
%token<num> EOS

%token<num> NUM

%type<num> program
%type<num> stmt
%type<num> expr
%type<num> uexpr
%type<num> asnm_expr
%type<num> binexpr
%type<num> function
%type<num> assignment
%type<num> declaration
%type<num> unhandled

/* Set operator precedence, follows BODMAS rules. */
%left SUB 
%left ADD
%left MUL 
%left DIV 
%left MOD 
%left L_BRC R_BRC

%start program

%%
  
program
  : stmt
  | program stmt
  | program EOS             { debug("empty program"); }
  ;

stmt
  : expr EOS
  | assignment EOS
  ;
  
assignment
  : declaration EQ expr     { debug("identifier " + to_string($1)); }
  | ID EQ expr              { debug("identifier " + to_string($1)); }
  ;
  
declaration
  : ID_TYPE ID;
  ;
  
expr
  : unhandled
  | asnm_expr
  | uexpr
  | binexpr
  | function
  ;

uexpr
  : NUM                     { $$ = $1; }
  | ID                      { $$ = $1; }
  | L_BRC expr R_BRC        { $$ = $2; }
  | expr NUM                { $$ = $1 + $2; }
  | ADD expr                { $$ = $2; }
  | SUB expr                { $$ = -$2; }
  | B_COM expr              { $$ = ~(int)$2; }
  ;

asnm_expr
  : ID B_AND_EQ expr      { $$ = (int)$1 & (int)$3; }
  | ID B_OR_EQ expr       { $$ = (int)$1 | (int)$3; }
  | ID B_XOR_EQ expr      { $$ = (int)$1 ^ (int)$3; }
  | ID B_LSH_EQ expr      { $$ = (int)$1 << (int)$3; }
  | ID B_RSH_EQ expr      { $$ = (int)$1 >> (int)$3; }
  | ID ADD_EQ expr        { $$ = $1 + $3; }
  | ID MUL_EQ expr        { $$ = $1 * $3; }
  | ID POW_EQ expr        { $$ = pow($1, $3); }
  | ID SUB_EQ expr        { $$ = $1 - $3; }
  | ID DIV_EQ expr        { $$ = oprt('/', $1, $3); }
  | ID MOD_EQ expr        { $$ = oprt('%', $1, $3); }
  ;

binexpr
  : expr B_AND expr         { $$ = (int)$1 & (int)$3; }
  | expr B_OR expr          { $$ = (int)$1 | (int)$3; }
  | expr B_XOR expr         { $$ = (int)$1 ^ (int)$3; }
  | expr B_LSH expr         { $$ = (int)$1 << (int)$3; }
  | expr B_RSH expr         { $$ = (int)$1 >> (int)$3; }
  | expr ADD expr           { $$ = $1 + $3; }
  | expr MUL expr           { $$ = $1 * $3; }
  | expr POW expr           { $$ = pow($1, $3); }
  | expr SUB expr           { $$ = $1 - $3; }
  | expr DIV expr           { $$ = oprt('/', $1, $3); }
  | expr MOD expr           { $$ = oprt('%', $1, $3); }
  ;
  
function
  : PRINT expr              { cout << $2 << endl; }
  ;

unhandled
  : L_PRT
  | R_PRT
  | L_SQR
  | R_SQR
  | DOT
  | QMARK
  | COLON
  | COMMA
  | B_COM
  | B_AND
  | B_OR
  | B_XOR
  | B_LSH
  | B_RSH
  ;
%%