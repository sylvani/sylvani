#include <iostream>
#include "parser.hpp"

using namespace std;

int main(int argc, char **argv)
{
    yyparse();
    // cout << "Terminated without errors" << endl;
    return 0;
}
