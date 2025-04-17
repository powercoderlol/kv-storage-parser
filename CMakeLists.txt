cmake_minimum_required(VERSION 3.24)
project(kvql_parser)
set(CMAKE_CXX_STANDARD 20)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

set(BISON_OUTPUT_DIR ${PROJECT_SOURCE_DIR}/gen)
set(FLEX_OUTPUT_DIR ${PROJECT_SOURCE_DIR}/gen)

set(LEXER_SRC ${PROJECT_SOURCE_DIR}/kvql.l)
set(PARSER_SRC ${PROJECT_SOURCE_DIR}/kvql.y)

set(LEXER_OUTPUT ${FLEX_OUTPUT_DIR}/llkvql.cpp)
set(PARSER_OUTPUT ${BISON_OUTPUT_DIR}/yykvql.cpp)
set(PARSER_HEADER ${BISON_OUTPUT_DIR}/yykvql.h)

add_custom_command(
        OUTPUT ${LEXER_OUTPUT}
        COMMAND ${FLEX_EXECUTABLE} -o ${LEXER_OUTPUT} ${LEXER_SRC}
        DEPENDS ${LEXER_SRC} ${PARSER_OUTPUT}
        COMMENT "Generating lexer from ${LEXER_SRC}"
)

add_custom_command(
        OUTPUT ${PARSER_OUTPUT} ${PARSER_HEADER}
        COMMAND ${BISON_EXECUTABLE} -d -o ${PARSER_OUTPUT} ${PARSER_SRC}
        DEPENDS ${PARSER_SRC}
        COMMENT "Generating parser from ${PARSER_SRC}"
)

add_custom_target(generated
        DEPENDS ${LEXER_OUTPUT} ${PARSER_OUTPUT}
)

set(APP_SRC
    main.cpp
    storage.hpp
)

add_executable(${PROJECT_NAME} ${APP_SRC})
add_dependencies(${PROJECT_NAME} generated)

target_include_directories(${PROJECT_NAME} PRIVATE
        ${BISON_OUTPUT_DIR}
        ${FLEX_OUTPUT_DIR}
        ${PROJECT_SOURCE_DIR}
)
