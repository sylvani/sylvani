/*========================================================
 * Statements
 ========================================================*/
stmt            {fn_appl_stmt} | {sgl_stmt} | {grp_stmt} | {dclr_stmt} | {asnm_stmt} | {cond_stmt}

grp_stmt        {stmt_grp} {eos}
sgl_stmt        {cond_stmt} | {asnm_stmt}

asnm_stmt       {rtl_asnm_stmt} | {ltr_asnm_stmt}
ltr_asnm_stmt   {expr} {ltr_asnm} {id} {eos}
rtl_asnm_stmt   {type_spec}? {id} {asnm} {expr} {eos}

dclr_stmt       {id_dclr} {eos}
fn_appl_stmt    {fn_appl} {eos}

cond_stmt       {l_cond_stmt} | {r_cond_stmt}
l_cond_stmt     {cond_key} {expr} ( {sgl_stmt} | {grp_stmt} )
r_cond_stmt     ( {sgl_stmt} | {stmt_grp} ) {cond_key} {expr} {eos}

expr_stmt       {stmt_key} {expr} {eos}

stmt_grp        {lbrc} {sgl_stmt} ({sgl_stmt} | {grp_stmt})* {rbrc}

/*========================================================
 * Expressions
 ========================================================*/
expr            ( {fn_appl} | {expr_grp} | {stmt_grp} | {art_expr} )

art_expr        {oprn}* {op} {oprn} {art_expr}*

/**
 * { 2 + 3 }
 * { x * x, y * y }
 */
expr_grp        {lbrc} {expr} ({ls_sep} {expr})* {rbrc}

/*========================================================
 * 
 ========================================================*/

fn_appl         {id} {parm_ls}

parm_ls         {lprt} ( {id} ({ls_sep} {id})* )? {rprt}

oprn            {id} | {num} | {num_complex}

id              {id_char} ({digit} | {id_char})*
id_dclr         {type_spec} {id}
fn_type         {prm_type} ("," {prm_type})* "->" {prm_type}
type_spec       ( {id_sign}? {prm_type} ) | {fn_type}

asnm            "="
ltr_asnm        "->"

op              {pow_op} | {mult_op} | {sub_op} | {div_op} | {mod_op} | {sum_op} | {incr_op} | {decr_op}
incr_op         "+="
decr_op         "-="
mult_op         "*"
pow_op          "**"
sub_op          "-"
sum_op          "+"
div_op          "/"
mod_op          "%"
eq_op           "=="
gt_op           ">"
ge_op           ">="
lt_op           "<"
le_op           "<="

prm_type        Void | Num | Str | List | Bool

str             \"([^\\\"]|\\.)*\"

cond_key        while | if | until
stmt_key        return | yield | stop | exit | catch | throw  | is | type | print | import | export | from | assert;

bltn_id         error | void | true | false

/*========================================================
 * Numbers
 ========================================================*/

num_complex     {num} "i"

num             {mat_cst} | {hex_num} | {uint} | {int} | {float}
hex_num         0x[a-fA-F0-9]+
mat_cst         0c[A-Z]+

float           [+-]?[0-9]*([0-9]\.?|\.[0-9])[0-9]*([Ee][-+]?[0-9]+)
int             [+-]{uint}
uint            {digit}+

digit           [0-9]
id_char         [a-zA-Z_]

id_sign         const | dyn

lbrc            "{"
rbrc            "}"
lprt            "("
rprt            ")"

ls_sep          ","

ws              [ \t\n]+
eos             ;

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