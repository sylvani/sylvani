%option noyywrap
/* 
This tells flex to read only one input file 
makes the scanner not call `yywrap()' upon an end-of-file,
but simply assume that there are no more files to scan
(until the user points yyin at a new file and calls `yylex()' again). 
*/

%{
#pragma warning(disable 4996)
#define YYDEBUG 1

#include <iostream>
#include <cstdlib>
#include <string>
#include "parser.hpp"

using namespace std;

// extern int add_variable(char *var_name);
%}

num_complex     {num_litr}i
num_litr        [-+]?({hex}|{num})
hex             0x[a-fA-F0-9]+
num             [0-9]*([0-9]\.?|\.[0-9])[0-9]*([Ee][+-]?[0-9]+)?

symb_type       (Fn|Void|Num|Str|Bool)(\[\])*
symbol          {id_char}({digit}|{id_char})*

digit           [0-9]
id_char         [a-zA-Z_]
ws              [ \t\n]
eos             [;]

%%

{ws}+                       {}

{num_litr}                  { return NUM; }

"||"                        { return OR; }
"&&"                        { return AND; }
"!"                         { return NOT; }

"~"                         { return B_COM; }
"&"                         { return B_AND; }
"|"                         { return B_OR; }
"^"                         { return B_XOR; }
"<<"                        { return B_LSH; }
">>"                        { return B_RSH; }

"&="                        { return B_AND_EQ; }
"|="                        { return B_OR_EQ; }
"^="                        { return B_XOR_EQ; }
"<<="                       { return B_LSH_EQ; }
">>="                       { return B_RSH_EQ; }

"*="                        { return MUL_EQ; }
"+="                        { return ADD_EQ; }
"-="                        { return SUB_EQ; }
"/="                        { return DIV_EQ; }
"**="                       { return POW_EQ; }
"%="                        { return MOD_EQ; }

"+"                         { return ADD; }
"-"                         { return SUB; }
"*"                         { return MUL; }
"/"                         { return DIV; }
"%"                         { return MOD; }
"**"                        { return POW; }

"="                         { return L_ASNM; }
"->"                        { return R_ASNM; }

"=="                        { return EQ; }
"!="                        { return NEQ; }

"."                         { return DOT; }
"?"                         { return QMARK; }
":"                         { return COLON; }
","                         { return COMMA; }
{eos}                       { return EOS; }

"{"                         { return L_BRC; }
"}"                         { return R_BRC; }
"["                         { return L_SQR; }
"]"                         { return R_SQR; }
"("                         { return L_PRT; }
")"                         { return R_PRT; }

"print"                     { return PRINT; }

{symb_type}                 { return SYMB_TYPE; }

{symbol}                    { return SYMBOL; }

.                           { cout << "Scanner: unknown character '" << yytext << "' " << endl; }

%%
