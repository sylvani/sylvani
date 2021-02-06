/*========================================================
 * Statements
 ========================================================*/
/* stmt            {kwd_stmt} | {expr_stmt} | {fn_def_stmt} | {sgl_stmt} | {grp_stmt} | {dclr_stmt} | {asnm_stmt} | {cond_stmt} */

/* kwd_stmt        {keyword} {stmt} */

/* fn_def_stmt     {fn_def} {eos} */

stmt            {expr} {eos}

dclr_stmt       {id_dclr} {eos}
cond_stmt       {l_cond_stmt} | {r_cond_stmt}
/* if a do_b */
/* if a do_b else do_c */
/* if a if b else do_b else do_c */
l_cond_stmt     {cond_key} {expr} {stmt}
/* do_b if a */
/* do_b if a else do_c */
r_cond_stmt     {expr} {cond_key} {expr} {eos}

grp_stmt        {lbrc} ({stmt} | {grp_stmt})* {rbrc} {eos}

/*========================================================
 * Expressions
 ========================================================*/
expr            !{expr} | {id} | {id_dclr} | {literal} | {ternr_expr} | {rel_expr} | {fn_appl} | {artm_expr_grp} | {artm_expr}
ternr_expr      {expr} {option} {expr} {colon} {expr}
rel_expr        {expr} {rel_op} {expr}

asnm_expr       {r_asnm_expr} | {l_asnm_expr}
l_asnm_expr     {expr} {l_asnm} {id} {eos}
r_asnm_expr     ( {id_sign}? {id_type} )? {id} {r_asnm} {stmt}

/* -{ { x+2 } ** 2 } */
/* { 1 / { x - 2 } } */
artm_expr_grp   [+-]? {lbrc} {artm_expr} {rbrc}
/* x + 1 */
artm_expr       {expr} {artm_op} {expr}

/*========================================================
 * Functions
 ========================================================*/

fn_appl         {id} {parm_ls}

/* (Num a, Bool b): Str {}; */
fn_def          {fn_sign} {grp_stmt}

/* (Num a, Bool b): Str */
fn_sign         {lprt} ( {typed_id} ({ls_sep} {typed_id})* )? {rprt} {colon} {id_type}

parm_ls         {lprt} ( {id} ({ls_sep} {id})* )? {rprt}

literal         {num} | {num_complex} | {str_ltr}

id              {id_char} ({digit} | {id_char})*
id_dclr         {id_sign}? {typed_id}
typed_id        {id_type} {id}

r_asnm          "="
l_asnm          "->"

/*========================================================
 * Operators
 ========================================================*/
set_op          {set_in} | {set_ni} | {set_has} | {set_hsn} | {set_sub} | {set_sup} | {set_nsub} | {set_nsup}
set_in          in
set_ni          ni
set_has         has
set_hsn         hsn
set_sub         sub
set_sup         sup
set_nsub        nsub
set_nsup        nsup

artm_op         {pow_op} | {mlt_op} | {sub_op} | {div_op} | {mod_op} | {add_op}
mlt_op          "*"
pow_op          "**"
sub_op          "-"
add_op          "+"
div_op          "/"
mod_op          "%"


btw_op          {rsh_op} | {lsh_op} | {xor_op} | {bor_op} | {bnd_op} | {cmp_op}
cmp_op          "~"
bnd_op          "&"
bor_op          "|"
xor_op          "^"
lsh_op          "<<"
rsh_op          ">>"

lgc_op          {nd_op} | {or_op} | {nt_op}
nd_op           "&&"
or_op           "||"
nt_op           "!"

rel_op          {eq_op} | {gt_op} | {ge_op} | {lt_op} | {le_op}
ne_op           "!="
eq_op           "=="
gt_op           ">"
ge_op           ">="
lt_op           "<"
le_op           "<="

incr_op         "+="
decr_op         "-="

/* Num[] */
/* Num[Str] */
/* Num[Str][Num] */
/* Str[][][] */
ls_type         {id_type} {lsqr} (Num|Str)? {rsqr}

id_type         {ls_type} | Fn | Void | Num | Str | Bool

str_ltr         \"([^\\\"]|\\.)*\"

keyword         {bltn_id} | {cond_key} | {stopper} | else | extends | catch  | is | type | print | import | export | from | assert;
stopper         return | yield | stop | exit | throw
cond_key        while | if | until

/* TODO: Test: _init = 1; Expect: "error: built-in IDs should not be assigned" */
bltn_id         _init | error | void | true | false
bltn_fn         num | str | map

/*========================================================
 * Numbers
 ========================================================*/

num_complex     {num}i

num             {mat_cst} | {hex_num} | {uint} | {int} | {float}
hex_num         0x[a-fA-F0-9]+
mat_cst         0c[A-Z]+

float           [+-]?[0-9]*([0-9]\.?|\.[0-9])[0-9]*([Ee][+-]?[0-9]+)
int             [+-]{uint}
uint            {digit}+

digit           [0-9]
id_char         [a-zA-Z_]

id_sign         const

/*========================================================
 * 
 ========================================================*/

empt_ls         {lsqr} {rsqr}
empt_grp        {lbrc} {rbrc}
empt_prt        {lprt} {rprt}

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

%{

int idcount = 0;
  
%}

%%

{id}            idcount++;
{ws}            ;
.               {ERROR; yyerror ("Unexpected character")}

%%

int yywrap(void) {
  return 1;
}

int main(void) {
  yylex();
  printf("Found %d identifiers\n", idcount);
  printf("Terminated without errors\n");
  return 0;
}