%top{
    #include <stdlib.h>

    #define TOKEN_INVALID 0
    #define TOKEN_LBRACE 1
    #define TOKEN_RBRACE 2
    #define TOKEN_STRING 3
    #define TOKEN_COLON 4
    #define TOKEN_COMMA 5
    #define TOKEN_LBRACK 6
    #define TOKEN_RBRACK 7
    #define TOKEN_NUMBER 8

    char **token_names;
}

NUMBER      -?(0|[1-9][0-9]*)(\.[0-9]+)?(E|e[-+]?[0-9]+)?
STRING      \"([^\"|\\|[:cntrl:]]|(\\([\"\\\/bfnrt]|u[0-9]{4})))*\"
BOOL        true|false
NULL        null
WS          [ \r\n\t]*

%%

"{"         {return TOKEN_LBRACE;}
"}"         {return TOKEN_RBRACE;}
{STRING}    {return TOKEN_STRING;}
{NUMBER}    {return TOKEN_NUMBER;}
":"         {return TOKEN_COLON;}
{WS}        /* discard whitespace */
.           {return TOKEN_INVALID;}

%%

void init() {
    token_names = (char **)malloc(100*sizeof(char *));
    token_names[TOKEN_INVALID] = "INVALID";
    token_names[TOKEN_LBRACE] = "LBRACE";
    token_names[TOKEN_RBRACE] = "RBRACE";
    token_names[TOKEN_STRING] = "STRING";
    token_names[TOKEN_COLON] = "COLON";
    token_names[TOKEN_COMMA] = "COMMA";
    token_names[TOKEN_LBRACK] = "LBRACK";
    token_names[TOKEN_RBRACK] = "RBRACK";
    token_names[TOKEN_NUMBER] = "NUMBER";
}

void done() {
    free(token_names);
}

int main() {
    init();
    for(int token = yylex();;token = yylex()) {printf("<%s>\n",token_names[token]);}
    done();
}

int yywrap() {
    return 1;
}