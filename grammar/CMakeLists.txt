# add macros to generate ANTLR Cpp code from grammar
find_package(ANTLR REQUIRED)

# Call macro to add lexer and grammar to your build dependencies.
antlr_target(Lexer Lexer.g4 LEXER
             PACKAGE wyrm_antlr)
antlr_target(Parser Parser.g4 PARSER
             PACKAGE wyrm_antlr
             DEPENDS_ANTLR Lexer
             COMPILE_FLAGS -lib ${ANTLR_Lexer_OUTPUT_DIR}
             LISTENER
            )

add_library(wyrm_antlr STATIC
            ${ANTLR_Lexer_CXX_OUTPUTS}
            ${ANTLR_Parser_CXX_OUTPUTS})

target_include_directories(wyrm_antlr PUBLIC
    ${ANTLR4_INCLUDE_DIRS}
    ${ANTLR_Lexer_OUTPUT_DIR}
    ${ANTLR_Parser_OUTPUT_DIR}
)

target_link_libraries(wyrm_antlr PUBLIC
    antlr4_static
)
