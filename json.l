%top{
#include <stack.h>
#define TOKEN_MODE 2

void doprint(char *);
void brackremode();
}

%{
int token_ct   = 0;
int invalid_ct = 0;

// the brack(et) stack 8)
Stack brackstack;
%}

%s in_array
%s in_array_finished_val

NUMBER      -?(0|[1-9][0-9]*)(\.[0-9]+)?(E|e[-+]?[0-9]+)?
STRING      \"([^\"|\\|[:cntrl:]]|(\\([\"\\\/bfnrt]|u[0-9]{4})))*\"
BOOL        true|false
NULL        null
WS          [ \r\n\t]*

VALUE       {NUMBER}|{STRING}|{BOOL}|{NULL}

%%
    /* array scanning */
"["{WS}                            {
    BEGIN(in_array);
    stack_pushc(&brackstack, '[');
    yymore();
    }

<in_array>{WS}{VALUE}{WS} {BEGIN(in_array_finished_val);yymore();}

<in_array_finished_val>{WS}","{WS} {BEGIN(in_array);yymore();}
<in_array_finished_val>{WS}"]"     {
        BEGIN(INITIAL);
        if(brackstack.size > 0) {
            if(stack_popc(&brackstack) == '[') {
                if(brackstack.size == 0) {
                    doprint("OBJECT");
                }
                else {
                    yymore();
                }
                brackremode();
            }
        }
    }

{NUMBER}	    {doprint("NUMBER");}
{STRING}        {doprint("STRING");}
{BOOL}          {doprint("BOOL");}
{WS}            /* discard whitespace */
.               {doprint("INVALID"); invalid_ct++;}
%%

void brackremode() {
    if(brackstack.size == 0) {
        BEGIN(INITIAL);
    }
    else {
        char brack = stack_peekc(&brackstack);
        switch(brack) {
        case '[':
            BEGIN(in_array_finished_val);
        }
    }
}

void doprint(char *ttype) {
    if(TOKEN_MODE == 2) {       // print token type and value
        printf("<%s:%s>\n", ttype, yytext);
    }
    else if(TOKEN_MODE == 1) {  // print token
        printf("<%s>\n", ttype);
    }
    token_ct++;
}

int main() {
    stack_init(&brackstack);

    yylex();
    printf("Parsed %d token(s), %d of which were invalid.\n", token_ct, invalid_ct);
}

int yywrap() {
    return 1;
}