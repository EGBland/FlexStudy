%top{
#include <arraylist.h>

#define TOKEN_INVALID 1
#define TOKEN_TERMINAL 2
#define TOKEN_NONTERMINAL 3
#define TOKEN_ARROW 4

#define TOKEN_MODE 1

ArrayList tlst;
ArrayList ntlst;

void doprint(char *, int);
int al_ismemstr(ArrayList *, char *);
}

%s DECL_TERMINAL_DONE
%s DECL_NONTERMINAL
%s DECL_NONTERMINAL_DONE
%s DECL_RULE_LEFT
%s DECL_RULE_ARROW
%s DECL_RULE_RIGHT

WS              [ \t]
WSALL           [ \t\r\n]
IDENTIFIER      [A-Za-z_][A-Za-z0-9_']*
LITERAL_STRING  \"([^\"|\\|[:cntrl:]]|(\\([\"\\\/bfnrt]|u[0-9]{4})))*\"
ARROW           "->"

%%
    /* terminal declarations (initial = decl_terminal) */
<INITIAL>{IDENTIFIER} {
    BEGIN(DECL_TERMINAL_DONE);
    doprint("TERMINAL", TOKEN_TERMINAL);
    return TOKEN_TERMINAL;
    }

<DECL_TERMINAL_DONE>{WS}+ {
    BEGIN(INITIAL);
    }

<INITIAL>{WS}*\n |
<DECL_TERMINAL_DONE>{WS}*\n {
    BEGIN(DECL_NONTERMINAL);
    }

    /* nonterminal declarations */
<DECL_NONTERMINAL>{IDENTIFIER} {
    BEGIN(DECL_NONTERMINAL_DONE);
    doprint("NONTERMINAL", TOKEN_NONTERMINAL);
    return TOKEN_NONTERMINAL;
    }

<DECL_NONTERMINAL_DONE>{WS}+ {
    BEGIN(DECL_NONTERMINAL);
    }

<DECL_NONTERMINAL>\n |
<DECL_NONTERMINAL_DONE>{WS}*\n {
    BEGIN(DECL_RULE_LEFT);
    }

<DECL_RULE_LEFT>{WS}*{IDENTIFIER} {
    BEGIN(DECL_RULE_ARROW);

    if(1) { // TODO check for nonterminal
        doprint("NONTERMINAL", TOKEN_NONTERMINAL);
        return TOKEN_NONTERMINAL;
    }
    else {
        return TOKEN_INVALID;
    }
    }

<DECL_RULE_ARROW>{WS}*{ARROW} {
    BEGIN(DECL_RULE_RIGHT);
    doprint("RULE_ARROW", TOKEN_ARROW);
    return TOKEN_ARROW; // TODO may not be necessary since LHS is always precisely one nonterminal
}

<DECL_RULE_RIGHT>{WS}*{IDENTIFIER} {
    if(1) { // TODO check that id is terminal/nonterminal
        doprint("TERMINAL", TOKEN_TERMINAL);
        return TOKEN_TERMINAL;
    }
    else if(1) {
        doprint("NONTERMINAL", TOKEN_NONTERMINAL);
        return TOKEN_NONTERMINAL;
    }
    else {
        doprint("INVALID", TOKEN_INVALID);
        return TOKEN_INVALID;
    }
}

<DECL_RULE_RIGHT>{WS}*\n {
    BEGIN(DECL_RULE_LEFT);
}

    /* catch-all */
. {
    doprint("INVALID", TOKEN_INVALID);
    return TOKEN_INVALID;
    }

%%

void doprint(char *token, int tid) {
    #if TOKEN_MODE==1
        fprintf(stderr, "<%s:%s>\n", token, yytext);
    #endif
    //printf("%d", tid);
}

int al_ismemstr(ArrayList *al, char *str) {
    for(int i = 0; i < al->len; i++) {
        char *astr = (char *)al_getptr(al, i);
        int r = 1;
        while(str[i]) {
            
        }
        if(r) return 1;
    }
    return 0;
}

int main() {
    al_init(&tlst);
    al_init(&ntlst);
    for(int token = yylex();token;token = yylex()) {
        
    }
}

int yywrap() { return 1; }