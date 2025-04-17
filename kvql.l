%{
#include "yykvql.hpp"
%}

%option noyywrap
%option nounput
%option noinput
%option nodefault

%x STRING_CONTENT

%%
\"          {
              BEGIN(STRING_CONTENT);
              print_lexer_stage("TOK_QUOTE", "\"");
              return TOK_QUOTE;
            }
<STRING_CONTENT>{
  \"        {
              BEGIN(INITIAL);
              print_lexer_stage("TOK_QUOTE", "\"");
              return TOK_QUOTE;
            }
  [^\"]+    {
              lvalp->str = strdup(yytext);
              print_lexer_stage("TOK_STRING", lvalp->str);
              return TOK_STRING;
            }
  <<EOF>>   {
              exit(1);
            }
}

"SET"       { print_lexer_stage("TOK_SET", "SET"); return TOK_SET; }
"GET"       { print_lexer_stage("TOK_GET", "GET"); return TOK_GET; }
"DEL"       { print_lexer_stage("TOK_DEL", "DEL"); return TOK_DEL; }

[ \t]+    ;  /* Skip whitespace */
\n          { return TOK_NEWLINE; }
.           { return (unsigned char)yytext[0]; }
%%
