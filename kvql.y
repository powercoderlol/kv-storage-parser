%lex-param      { Storage * pStorage }
%parse-param    { Storage * pStorage }
%define api.pure
%define parse.error verbose

%token TOK_STRING
%token TOK_SET TOK_GET TOK_DEL
%token TOK_QUOTE
%token TOK_NEWLINE

%%
commands: /* empty */
        | commands command TOK_NEWLINE
        | TOK_NEWLINE
        ;

command: set_command
       | get_command
       | del_command
       ;

set_command:
    TOK_SET quoted_string quoted_string
    {
        print_parser_stage("SET command");
        pStorage->Set($2.str, $3.str);
    }
    ;

get_command:
    TOK_GET quoted_string
    {
        print_parser_stage("GET command");
        auto res = pStorage->Get($2.str);
        if(res.empty()) {
            std::cout << "empty\n";
        } else {
            std::cout << res << std::endl;
        }

    }
    ;

del_command:
    TOK_DEL quoted_string
    {
        print_parser_stage("DEL command");
        size_t res = pStorage->Del($2.str);
        if(res == 0) {
            std::cout << "empty\n";
        } else {
            std::cout << "deleted\n";
        }
    }
    ;

quoted_string:
    TOK_QUOTE TOK_STRING TOK_QUOTE
    {
        print_parser_stage("quoted string");
        $$.str = $2.str;
    }
    ;
%%
