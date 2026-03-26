%{
#include "calc.tab.h"
#include <stdlib.h>
%}

%%

[ \t\n]+          { /* skip whitespace */ }
[0-9]*\.[0-9]+  { yylval.fval = atof(yytext); return FNUM; }
[0-9]+          { yylval.ival = atoi(yytext); return NUM; }
"^"             { return EXPO; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"#"[^\n]* { /* skip comment */ }
.               { printf("Unknown: %s\n", yytext); }

%%

int yywrap(void) { return 1; }
