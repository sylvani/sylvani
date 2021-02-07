#include <iostream>
#include "parser.hpp"

using namespace std;

extern int yylex(void);
extern char *yytext;

int main(int argc, char **argv)
{
    yyparse();

    int token;
    while ((token = yylex()) != 0)
        cout << "Token: (" << token << ") " << yytext << endl;

    return 0;
}
