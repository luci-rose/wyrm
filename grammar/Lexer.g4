lexer grammar Lexer;

// Lexer rules are in priority order, so need to define more specific tokens
// before more general ones.

STRING : '"' (~["\\] |'\\' .)* '"' ;

SYMBOL_QUOTE : '\'' (~['\\]|'\\' .)* '\'' ;
SYMBOL_SLASH : '\\' [a-zA-Z0-9_]* ;

// Comments (not to be confused with binops)
COMMENT_LINE : '//' ~('\n')*? ('\n'|EOF) -> channel(2) ;
COMMENT_BLOCK : '/*' (COMMENT_BLOCK|.)*? '*/' -> channel(2) ;

// Reserved words
CLASSVAR : 'classvar' ;
CONST : 'const' ;
FALSE : 'false' ;
FLOAT : 'float' ;
IF : 'if' ;
INF : 'inf' ;
INT : 'int' ;
LONG : 'long' ;
NIL : 'nil' ;
PI : 'pi' ;
TRUE : 'true' ;
VAR : 'var' ;
WHILE : 'while' ;

CHARACTER : '$' (.|'\\'.) ;

CLASSNAME : [A-Z] [a-zA-Z0-9_]* ;

FLOAT_LITERAL : [0-9]+ '.' [0-9]+ ;
FLOAT_SCI : [0-9]+ ('.' [0-9]+)? 'e' ('-' | '+')? [0-9]+ ;

INT_LITERAL : [0-9]+ ;
INT_HEX : '0x' [0-9a-fA-F]* ;
INT_RADIX : [1-9] [0-9]* 'r' [a-zA-Z0-9]+ ;

KEYWORD : [a-zA-Z0-9_]+ ':' ;

NAME : [a-z] [a-zA-Z0-9_]* ;

ARROW_LEFT : '<-' ;
ASTERISK : '*' ;
EQUALS : '=' ;
GREATER_THAN : '>' ;
LESS_THAN : '<' ;
MINUS : '-' ;
PIPE : '|' ;
PLUS : '+' ;
READ_WRITE : '<>' ;

// Delimiters.
CARET : '^' ;
COLON : ':' ;
COMMA : ',' ;
CURLY_OPEN : '{' ;
CURLY_CLOSE : '}' ;
PAREN_OPEN : '(' ;
PAREN_CLOSE : ')' ;
SQUARE_OPEN : '[' ;
SQUARE_CLOSE : ']' ;
SEMICOLON : ';' ;

DOT : '.' ;
DOT_DOT : '..' ;
ELLIPSES : '...' ;

SPACE: ' ' -> channel(HIDDEN) ;
TAB: '\t' -> channel(HIDDEN) ;
CARRIAGE_RETURN: '\r' -> channel(HIDDEN) ;
NEWLINE: '\n' -> channel(HIDDEN) ;
