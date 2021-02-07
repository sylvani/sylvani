%defines

%{
  
#include <iostream>
#include <cstdlib>
#include <string>
#include <cmath>
#include "utils.hpp"

/* Used for variable stores. Defined in mem.hpp */
extern int set_variable(int index, double val);
extern int variable_set[100];
extern double variable_values[100];

/* Flex functions */
extern int yylex(void);
extern void yyterminate();
void yyerror(const char *s);
extern FILE* yyin;
  
%}

%union {
	int index;
	double num;
}

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
%token<num> VAR_KEYWORD 
%token<index> VARIABLE
%token<num> EOL
%type<num> program
%type<num> calculation
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
	
program: calculation EOL  { printf("=%.2f\n",$1); }
    ;

calculation:
		  expr
		| function
		| assignment
		;
		
constant: PI { $$ = 3.1415926535; }
		;
		
expr:
			SUB expr					{ $$ = -$2; }
    | NUMBER            { $$ = $1; }
		| VARIABLE					{ $$ = variable_values[$1]; }
		| constant	
		| function
		| expr DIV expr     { if ($3 == 0) { yyerror("Cannot divide by zero"); exit(1); } else $$ = $1 / $3; }
		| expr MUL expr     { $$ = $1 * $3; }
		| L_BRC expr R_BRC	{ $$ = $2; }
		| expr ADD expr     { $$ = $1 + $3; }
		| expr SUB expr   	{ $$ = $1 - $3; }
		| expr POW expr     { $$ = pow($1, $3); }
		| expr MOD expr     { $$ = modulo($1, $3); }
    ;
		
function:
			conversion
		| log_function
		| trig_function
		| hyperbolic_function
		|	SQRT expr      		{ $$ = sqrt($2); }
		| expr FACTORIAL		{ $$ = factorial($1); }
		| ABS expr 					{ $$ = abs($2); }
		| FLOOR expr 				{ $$ = floor($2); }
		| CEIL expr 				{ $$ = ceil($2); }
		;

trig_function:
			COS expr  			  { $$ = cos($2); }
		| SIN expr 					{ $$ = sin($2); }
		| TAN expr 					{ $$ = tan($2); }
		;
	
log_function:
			LOG2 expr 				{ $$ = log2($2); }
		| LOG10 expr 				{ $$ = log10($2); }
		;
		
hyperbolic_function:
			COSH expr  			  { $$ = cosh($2); }
		| SINH expr 				{ $$ = sinh($2); }
		| TANH expr 				{ $$ = tanh($2); }
		;
		
conversion
		: temperature_conversion
		| distance_conversion
		;

temperature_conversion
		:	expr CEL_TO_FAH 	{ $$ = cel_to_fah($1); }
		| expr FAH_TO_CEL 	{ $$ = fah_to_cel($1); }

distance_conversion
		: expr M_TO_KM 			{ $$ = m_to_km($1); }
		| expr KM_TO_M 			{ $$ = km_to_m($1); }
		
assignment: 
		VAR_KEYWORD VARIABLE EQ calculation { $$ = set_variable($2, $4); }
		;
%%

void yyerror(const char *msg) {
  std::cout << "Failed to parse: " << msg << std::endl;
}