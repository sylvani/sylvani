/*========================================================
 * Statements
 ========================================================*/
stmt            {ternr_expr_stmt} | {fn_def_stmt} | {fn_appl_stmt} | {sgl_stmt} | {grp_stmt} | {dclr_stmt} | {asnm_stmt} | {cond_stmt}

ternr_expr_stmt {ternr_expr} {eos}

fn_def_stmt     {fn_def} {eos}

grp_stmt        {stmt_grp} {eos}
sgl_stmt        {cond_stmt} | {asnm_stmt}

asnm_stmt       {r_asnm_stmt} | {l_asnm_stmt}
l_asnm_stmt     ( {expr} | {stmt_grp} ) {l_asnm} {id} {eos}
r_asnm_stmt     ( {id_sign}? {id_type} )? {id} {r_asnm} {stmt}

dclr_stmt       {id_dclr} {eos}
fn_appl_stmt    {fn_appl} {eos}

cond_stmt       {l_cond_stmt} | {r_cond_stmt}
l_cond_stmt     {cond_key} {expr} ( {sgl_stmt} | {grp_stmt} )
r_cond_stmt     ( {sgl_stmt} | {stmt_grp} ) {cond_key} {expr} {eos}

expr_stmt       {stmt_key}? {expr} {eos}

stmt_grp        {lbrc} {sgl_stmt} ({sgl_stmt} | {grp_stmt})* {rbrc}

/*========================================================
 * Expressions
 ========================================================*/
expr            ( {fn_appl} | {expr_grp} | {stmt_grp} | {artm_expr} )

artm_expr       {oprn} {artm_op} {oprn}

ternr_expr      ( {expr} | {stmt_grp} ) {option} {stmt_grp}

/* term            {fctr} ({mlt_op}|{div_op}|{mod_op}) {fctr} */

/**
 * { 2 + 3 }
 * -{ { x + 1 } ** 2 - 3 * x + 1 }
 */
expr_grp        [+-]? {lbrc} {expr}* {expr_grp}* {expr}* {rbrc}

/*========================================================
 * Functions
 ========================================================*/

fn_appl         {id} {parm_ls}

/* (Num a, Bool b): Str {}; */
fn_def          {fn_sign} {grp_stmt}

/* (Num a, Bool b): Str */
fn_sign         {lprt} ( {typed_id} ({ls_sep} {typed_id})* )? {rprt} {colon} {id_type}

parm_ls         {lprt} ( {id} ({ls_sep} {id})* )? {rprt}

oprn            {id} | {num} | {num_complex} | {str_ltr}

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

keyword         {bltn_id} | {cond_key} | extends | {stopper} | catch  | is | type | print | import | export | from | assert;
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