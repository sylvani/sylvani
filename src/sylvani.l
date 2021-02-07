%option noyywrap
/* 
This tells flex to read only one input file 
makes the scanner not call `yywrap()' upon an end-of-file,
but simply assume that there are no more files to scan
(until the user points yyin at a new file and calls `yylex()' again). 
 */

%{

#include "parser.hpp"

int idcount = 0;

%}

hex_num         0x[a-fA-F0-9]+
mat_cst         0c[A-Z]+

digit           [0-9]
id_char         [a-zA-Z_]

id_sign         const

binop           [-+*%/]

lsqr            "["
rsqr            "]"
lbrc            "{"
rbrc            "}"
lprt            "("
rprt            ")"

acc_prop        "."
option          "?"
colon           ":"
ls_sep          ","
eos             ";"

ws              [ \t\n]

%%

{digit}+ {
  yylval.dbl = atof(yytext);
  return LITR_DBL;
}

{binop} { return yytext[0]; }
\n { return '\n'; }
.

%%

/* int main(void) {
  yylex();
  printf("Found %d identifiers\n", idcount);
  printf("Terminated without errors\n");
  return 0;
} */
