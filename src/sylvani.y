%defines

%token SYMBOL

%token PRINT

%token L_ASNM R_ASNM

%token L_BRC R_BRC
%token L_PRT R_PRT
%token L_SQR R_SQR

%token DOT QMARK COLON COMMA
%token B_COM B_AND B_OR B_XOR B_LSH B_RSH
%token POW MOD DIV MUL ADD SUB EQ NEQ
%token MUL_EQ ADD_EQ SUB_EQ POW_EQ MOD_EQ DIV_EQ
%token B_AND_EQ B_OR_EQ B_XOR_EQ B_LSH_EQ B_RSH_EQ
%token AND OR NOT

%token SYMB_TYPE 
%token EOS

%token NUM

%type program
%type stmt
%type expr
%type asnm_expr
%type binexpr
%type function
%type assignment
%type declaration
%type unhandled

/* Set operator precedence, follows BODMAS rules. */
%left  COMMA
%right QMARK COLON L_ASNM ADD_EQ SUB_EQ NOT
%left  OR AND
%left  EQ NEQ R_ASNM
%left  ADD SUB
%left  MUL
%right B_AND
%left  L_BRC

%start program

%{

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

%%
  
program
  : stmt
  | program stmt
  ;

stmt
  : expr EOS
  | assignment EOS
  ;
  
assignment
  : declaration L_ASNM expr   { debug("identifier " + to_string($1)); }
  | SYMBOL L_ASNM expr        { debug("identifier " + to_string($1)); }
  ;
  
declaration
  : SYMB_TYPE SYMBOL          { debug("declr "); }
  ;
  
expr
  : unhandled
  | asnm_expr
  | binexpr
  | function
  | SYMBOL                    { $$ = $1; }
  | NUM                       { $$ = $1; }
  | L_BRC expr R_BRC          { $$ = $2; }
  | ADD expr                  { $$ = $2; }
  | SUB expr                  { $$ = -$2; }
  | expr NUM                  { $$ = $1 + $2; }
  | B_COM expr                { $$ = ~(int)$2; }
  ;

asnm_expr
  : SYMBOL B_AND L_ASNM expr      { $$ = (int)$1 & (int)$3; }
  | SYMBOL B_OR L_ASNM expr       { $$ = (int)$1 | (int)$3; }
  | SYMBOL B_XOR L_ASNM expr      { $$ = (int)$1 ^ (int)$3; }
  | SYMBOL B_LSH L_ASNM expr      { $$ = (int)$1 << (int)$3; }
  | SYMBOL B_RSH L_ASNM expr      { $$ = (int)$1 >> (int)$3; }
  | SYMBOL ADD L_ASNM expr        { $$ = $1 + $3; }
  | SYMBOL MUL L_ASNM expr        { $$ = $1 * $3; }
  | SYMBOL POW L_ASNM expr        { $$ = pow($1, $3); }
  | SYMBOL SUB L_ASNM expr        { $$ = $1 - $3; }
  | SYMBOL DIV L_ASNM expr        { $$ = oprt('/', $1, $3); }
  | SYMBOL MOD L_ASNM expr        { $$ = oprt('%', $1, $3); }
  ;

binexpr
  : expr B_AND expr           { $$ = (int)$1 & (int)$3; }
  | expr B_OR expr            { $$ = (int)$1 | (int)$3; }
  | expr B_XOR expr           { $$ = (int)$1 ^ (int)$3; }
  | expr B_LSH expr           { $$ = (int)$1 << (int)$3; }
  | expr B_RSH expr           { $$ = (int)$1 >> (int)$3; }
  | expr ADD expr             { $$ = $1 + $3; }
  | expr MUL expr             { $$ = $1 * $3; }
  | expr POW expr             { $$ = pow($1, $3); }
  | expr SUB expr             { $$ = $1 - $3; }
  | expr DIV expr             { $$ = oprt('/', $1, $3); }
  | expr MOD expr             { $$ = oprt('%', $1, $3); }
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
  | R_ASNM
  ;
%%