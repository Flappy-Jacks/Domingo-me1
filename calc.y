%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int depth = 0;
typedef struct Node {
    char label[20];
    struct Node *left, *mid, *right;
} Node;

Node* makeNode(char* lbl, Node* l, Node* m, Node* r) {
    Node* n = malloc(sizeof(Node));
    strcpy(n->label, lbl);
    n->left = l; n->mid = m; n->right = r;
    return n;
}

void indent(int d) {
    for (int i = 0; i < d * 2; i++) putchar(' ');
}

void printTree(Node* n) {
    if (!n) return;

    indent(depth);
    printf("%s\n", n->label);

    depth++;
    printTree(n->left);
    printTree(n->mid);
    printTree(n->right);
    depth--;
}

void yyerror(const char *s);
int yylex();
%}

%union {
    int ival;
    double fval;
    struct Node* nptr;
}

%token <ival> NUM
%token <fval> FNUM
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN EXPO
%type <nptr> expr term factor

%%

program:
    expr { printTree($1); }
    ;

expr:
    expr PLUS term  { $$ = makeNode("expr", $1, makeNode("+",0,0,0), $3); }
    | expr MINUS term { $$ = makeNode("expr", $1, makeNode("-",0,0,0), $3); }
    | term           { $$ = makeNode("expr", $1, NULL, NULL); }
    ;

term:
    term TIMES factor    { $$ = makeNode("term", $1, makeNode("*",0,0,0), $3); }
    | term DIVIDE factor { $$ = makeNode("term", $1, makeNode("/",0,0,0), $3); }
    | factor EXPO term   { $$ = makeNode("term", $1, makeNode("^",0,0,0), $3); }
    | factor             { $$ = makeNode("term", $1, NULL, NULL); }
    ;

factor:
    NUM { 
        char buf[20]; sprintf(buf, "%d", $1);
        $$ = makeNode("factor", makeNode(buf,0,0,0), NULL, NULL); 
    }
    | FNUM {
        char buf[20]; sprintf(buf, "%g", $1);
        $$ = makeNode("factor", makeNode(buf,0,0,0), NULL, NULL);
    }
    | MINUS factor {
        $$ = makeNode("factor", makeNode("-",0,0,0), $2, NULL);
    }
    | LPAREN expr RPAREN { $$ = makeNode("factor", $2, NULL, NULL); }
    ;

%%

void yyerror(const char *s) { fprintf(stderr, "%s\n", s); }
int main() { return yyparse(); }
