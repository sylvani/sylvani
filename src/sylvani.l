%option noyywrap
/* 
This tells flex to read only one input file 
makes the scanner not call `yywrap()' upon an end-of-file,
but simply assume that there are no more files to scan
(until the user points yyin at a new file and calls `yylex()' again). 
*/

%{
#include <iostream>
#include <cstdlib>
#include <string>
#include "parser.hpp"
#include "mem.hpp"

using namespace std;

// void yyerror(string msg);
%}

num_complex     {num_litr}i
num_litr        [-+]?({hex}|{num})
hex             0x[a-fA-F0-9]+
num             [0-9]*([0-9]\.?|\.[0-9])[0-9]*([Ee][+-]?[0-9]+)?

id_type         Fn|Void|Num|Str|Bool
id              {id_char}({digit}|{id_char})*

digit           [0-9]
id_char         [a-zA-Z_]
ws              [ \t\n]

%%

{ws}+

{num_litr}                  {
                              yylval.num = atof(yytext);
                              cout << "number " << yytext << endl;
                              return NUMBER;
                            }

"+"                         { return ADD; }
"-"                         { return SUB; }
"*"                         { return MUL; }
"/"                         { return DIV; }
"%"													{ return MOD; }
"**"                        { return POW; }
"="													{ return EQ; }

"."                         { return DOT; }
"?"                         { return QMARK; }
":"                         { return COLON; }
","                         { return COMMA; }
";"                         { return EOS; }

"{"   											{ return L_BRC; }
"}"   											{ return R_BRC; }
"["											    { return L_SQR; }
"]"   											{ return R_SQR; }
"("   											{ return L_PRT; }
")"   											{ return R_PRT; }

"0cPi"											{ cout << "It's Pi" << endl; return PI; }
"0cE"											  { return EULER; }

"fac"                       { return FACTORIAL; }
"mod"												{ return MOD; }
"pow"												{	return POW; }
"floor"				  					  { return FLOOR; }
"ceil"											{ return CEIL; }
"abs"												{ return ABS; }
"cos"												{ return COS; }
"sin"												{ return SIN; }
"tan"												{ return TAN; }
"sinh"											{ return SINH; }
"cosh"											{ return COSH; }
"tanh"											{ return TANH; }
"sqrt"											{ return SQRT; }
"log2"											{ return LOG2; }
"log10"										  { return LOG10; }
"cel_to_fah"					      { return CEL_TO_FAH; }
"fah_to_cel"					      { return FAH_TO_CEL; }
"km_to_m"								    { return KM_TO_M; }
"m_to_km"								    { return M_TO_KM; }
{id_type}										{ return ID_TYPE; }

{id}                  			{
                              cout << "Variable '" << yytext << "'" << endl;
                              yylval.index = add_variable(yytext);
                              return ID;
                            }

.                           { cout << "Scanner: unknown character '" << yytext << "' " << endl; }

%%