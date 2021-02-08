#include <iostream>
#include "parser.hpp"

using namespace std;

extern int yylex(void);
extern char *yytext;
extern FILE *yyin;

int main(int argc, char **argv)
{
  int error = 0;

  FILE *pt = fopen(argv[1], "r");
  if (!pt)
  {
    cout << "Parser: no file input" << endl;
    error = yyparse();
  }
  else
  {
    yyin = pt;

    do
    {
      error = yyparse();
    } while (!feof(yyin));
  }

  if (error == 0)
  {
    cout << "Parser: success" << endl;
    return 0;
  }

  int token;
  while ((token = yylex()) != 0)
    cout << "Token: (" << token << ") " << yytext << endl;

  cout << "Parser: failed" << endl;
  return 1;
}
