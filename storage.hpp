//
// Created by Ivan Polyakov on 17.04.2025.
//

#pragma once

#include <unordered_map>
#include <string>
#include <iostream>

class Storage {
public:
  int Process();

  void Set(const std::string &key, const std::string &value) {
    this->storage[key] = value;
  }

  std::string Get(const std::string &key) {
    auto it = this->storage.find(key);
    if (it == this->storage.end()) {
      return "";
    }
    return it->second;
  }

  size_t Del(const std::string &key) {
    return this->storage.erase(key);
  }

private:
  std::unordered_map<std::string, std::string> storage;
};

struct CommandData {
  std::string str;
};
#define YYSTYPE CommandData

#define YY_DECL static int my_lex(YYSTYPE * lvalp, Storage * pStorage)

inline void print_lexer_stage(const std::string& token_type, const std::string& value) {
    std::cout << "[LEXER] " << token_type << ": " << value << '\n';
}

inline void print_parser_stage(const std::string& stage) {
    std::cout << "[PARSER] " << stage << "\n";
}

#include "gen/llkvql.cpp"

static void yyerror(Storage *pStorage, const char *szMessage) {
  std::cout << "Error\n";
}

static int yylex(YYSTYPE *yylval, Storage *pStorage) {
  return my_lex(yylval, pStorage);
}

#include "gen/yykvql.cpp"

inline int Storage::Process() {
  return yyparse(this);
}
