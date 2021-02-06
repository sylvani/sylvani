/*========================================================
 * Statements
 ========================================================*/
stmt            {kwd_stmt} | {expr_stmt} | {fn_def_stmt} | {sgl_stmt} | {grp_stmt} | {dclr_stmt} | {asnm_stmt} | {cond_stmt}

kwd_stmt        {keyword} {stmt}

fn_def_stmt     {fn_def} {eos}

grp_stmt        {stmt_grp} {eos}
sgl_stmt        {cond_stmt} | {asnm_stmt}

asnm_stmt       {r_asnm_stmt} | {l_asnm_stmt}
l_asnm_stmt     {expr} {l_asnm} {id} {eos}
r_asnm_stmt     ( {id_sign}? {id_type} )? {id} {r_asnm} {stmt}

dclr_stmt       {id_dclr} {eos}

cond_stmt       {l_cond_stmt} | {r_cond_stmt}
l_cond_stmt     {cond_key} {expr} ( {sgl_stmt} | {grp_stmt} )
r_cond_stmt     ( {sgl_stmt} | {stmt_grp} ) {cond_key} {expr} {eos}

expr_stmt       {expr} {eos}

stmt_grp        {lbrc} {sgl_stmt} ({sgl_stmt} | {grp_stmt})* {rbrc}

/*========================================================
 * Expressions
 ========================================================*/
expr            {id} | {literal} | {ternr_expr} | {rel_expr} | {fn_appl} | {artm_expr_grp} | {stmt_grp} | {artm_expr}
ternr_expr      {expr} {option} {expr} {colon} {expr}
rel_expr        {expr} {rel_op} {expr}

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

keyword         {bltn_id} | {cond_key} | {stopper} | extends | catch  | is | type | print | import | export | from | assert;
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

ws              [ \t\n]+

%{

int id_count = 0;
  
%}

%%

{id}                  id_count++;

%%

int yywrap(void) {
  return 1;
}

int main(void) {
  yylex();
  printf("Terminated without errors\n");
  return 0;
}