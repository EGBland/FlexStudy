%top{
    #include <stdlib.h>

    #define TOKEN_INVALID 1
    #define TOKEN_LBRACE 2
    #define TOKEN_RBRACE 3
    #define TOKEN_STRING 4
    #define TOKEN_COLON 5
    #define TOKEN_COMMA 6
    #define TOKEN_LBRACK 7
    #define TOKEN_RBRACK 8
    #define TOKEN_NUMBER 9
    #define TOKEN_BOOL 10
    #define TOKEN_NULL 11

    #define DEBUG_INVALID_TOKENS 1

    char **token_names;

    int token_ct;
    int invalid_ct;
}

NUMBER      -?(0|[1-9][0-9]*)(\.[0-9]+)?(E|e[-+]?[0-9]+)?
STRING      \"([^\"\\[:cntrl:]]|(\\([\"\\\/bfnrt]|u[0-9]{4})))*\"
BOOL        true|false
NULL        null
WS          [ \r\n\t]*

%%

"{"         {token_ct++;return TOKEN_LBRACE;}
"}"         {token_ct++;return TOKEN_RBRACE;}
"["         {token_ct++;return TOKEN_LBRACK;}
"]"         {token_ct++;return TOKEN_RBRACK;}
{BOOL}      {token_ct++;return TOKEN_BOOL;}
{NULL}      {token_ct++;return TOKEN_NULL;}
{STRING}    {token_ct++;return TOKEN_STRING;}
{NUMBER}    {token_ct++;return TOKEN_NUMBER;}
":"         {token_ct++;return TOKEN_COLON;}
","         {token_ct++;return TOKEN_COMMA;}
{WS}        /* discard whitespace */
.           {token_ct++;invalid_ct++;return TOKEN_INVALID;}

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
    token_names[TOKEN_BOOL] = "BOOL";
    token_names[TOKEN_NULL] = "NULL";
}

void done() {
    free(token_names);
}

int main() {
    init();
    for(int token = yylex();token;token = yylex()) {
        #if DEBUG_INVALID_TOKENS
        if(token == TOKEN_INVALID) {
            printf("<INVALID:%s>\n",yytext);
        }
        #else
        printf("<%s>\n",token_names[token]);
        #endif
    }
    printf("Parsed %d token(s), %d of which were invalid.\n", token_ct, invalid_ct);
    done();
}

int yywrap() {
    return 1;
}