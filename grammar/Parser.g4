parser grammar Parser;

options {
  tokenVocab=Lexer;
}

root : topLevelStatement* EOF ;

topLevelStatement : classDef
                  | classExtension
                  | interpreterCode
                  ;

classDef : CLASSNAME superclass? CURLY_OPEN classVarDecl* methodDef* CURLY_CLOSE
         | CLASSNAME SQUARE_OPEN name? SQUARE_CLOSE superclass? CURLY_OPEN classVarDecl* methodDef* CURLY_CLOSE
         ;

superclass : COLON CLASSNAME ;

classVarDecl : CLASSVAR rwSlotDefList SEMICOLON
             | VAR rwSlotDefList SEMICOLON
             | CONST constDefList SEMICOLON
             ;

rwSlotDefList : rwSlotDef (COMMA rwSlotDef)* ;

rwSlotDef : rwSpec? name (EQUALS literal)? ;

rwSpec : LESS_THAN
       | GREATER_THAN
       | READ_WRITE
       ;

name : NAME
     | WHILE
     ;

literal : coreLiteral
        | list
        ;

coreLiteral : integer
            | floatingPoint
            | strings
            | symbol
            | booleanConstant
            | CHARACTER
            | NIL
            ;

integer : integerNumber
        | MINUS integerNumber
        ;

integerNumber : INT
              | INT_HEX
              | INT_RADIX
              ;

floatingPoint : floatLiteral
              | floatLiteral PI
              | integer PI
              | PI
              | MINUS PI
              | accidental
              ;

floatLiteral : floatNumber
             | MINUS floatNumber
             ;

floatNumber : FLOAT
            | FLOAT_RADIX
            | FLOAT_SCI
            | INF
            ;

accidental : FLOAT_FLAT
           | FLOAT_FLAT_CENTS
           | FLOAT_SHARP
           | FLOAT_SHARP_CENTS
           ;

strings : STRING+ ;

symbol : SYMBOL_QUOTE
       | SYMBOL_SLASH
       ;

booleanConstant : TRUE
                | FALSE
                ;

list : HASH innerListLiteral ;

innerListLiteral : SQUARE_OPEN listLiterals? SQUARE_CLOSE
                 | CLASSNAME SQUARE_OPEN listLiterals? SQUARE_CLOSE
                 ;

listLiteral : coreLiteral
            | innerListLiteral
            | innerDictLiteral
            | name
            ;

listLiterals : listLiteral (COMMA listLiteral)* ;

innerDictLiteral : PAREN_OPEN dictLiterals? PAREN_CLOSE ;

dictLiterals : dictLiteral (COMMA dictLiteral)* COMMA? ;

dictLiteral : listLiteral COLON listLiteral
            | KEYWORD listLiteral
            ;

constDefList : rSlotDef (COMMA rSlotDef)* ;

rSlotDef   : LESS_THAN? name
           | LESS_THAN? name EQUALS literal
           ;

methodDef : ASTERISK? methodDefName CURLY_OPEN argDecls? varDecls? primitive? body? CURLY_CLOSE ;

methodDefName : name
              | binop
              ;

argDecls : ARG varDefList SEMICOLON
         | ARG varDefList? ELLIPSES name SEMICOLON
         | PIPE pipeDefList PIPE
         | PIPE pipeDefList? ELLIPSES name PIPE
         ;

varDefList : varDef (COMMA varDef)* ;

varDef : name
       | name EQUALS expr
       | name PAREN_OPEN exprSeq PAREN_CLOSE
       ;

expr : literal                                                                                   # ExprLiteral
     | block                                                                                     # ExprBlock
     | listComp                                                                                  # ExprListComp
     | name                                                                                      # ExprName
     | UNDERSCORE                                                                                # ExprCurryArg
     | PAREN_OPEN exprSeq PAREN_CLOSE                                                            # ExprExprSeq
     | TILDE name                                                                                # ExprGlobal
     | GRAVE expr                                                                                # ExprGrave
     | SQUARE_OPEN arrayElems? SQUARE_CLOSE                                                      # ExprArray
     | PAREN_OPEN numericSeries PAREN_CLOSE                                                      # ExprNumericSeries
     | PAREN_OPEN COLON numericSeries PAREN_CLOSE                                                # ExprNumericSeriesSuffix
     | PAREN_OPEN dictElements? PAREN_CLOSE                                                      # ExprNewEvent
     | expr SQUARE_OPEN argList SQUARE_CLOSE                                                     # ExprArrayRead
     | expr SQUARE_OPEN argList SQUARE_CLOSE EQUALS expr                                         # ExprArrayWrite
        // IndexSeries
     | expr SQUARE_OPEN argList DOT_DOT exprSeq? SQUARE_CLOSE                                    # ExprIndexSeries
     | expr SQUARE_OPEN DOT_DOT exprSeq SQUARE_CLOSE                                             # ExprIndexSeriesSuffix
        // IndexSeriesAssign (expr)
     | expr SQUARE_OPEN argList DOT_DOT exprSeq? SQUARE_CLOSE EQUALS expr                        # ExprIndexSeriesAssign
     | expr SQUARE_OPEN DOT_DOT exprSeq SQUARE_CLOSE EQUALS expr                                 # ExprIndexSeriesAssignSuffix
     | CLASSNAME                                                                                 # ExprClassname
     | expr binopKey adverb? expr                                                                # ExprBinop
     | name EQUALS expr                                                                          # ExprAssign
     | TILDE name EQUALS expr                                                                    # ExprAssignGlobal
     | expr DOT name EQUALS expr                                                                 # ExprAssignDotName
     | name PAREN_OPEN argList keyArgList? PAREN_CLOSE EQUALS expr                               # ExprAssignTBD
     | HASH multiAssignVars EQUALS expr                                                          # ExprMultiAssign
     // messages
     | PAREN_OPEN binopKey PAREN_CLOSE blockArgList                                              # ExprMsgKeyBlock
     | name (PAREN_OPEN PAREN_CLOSE)? blockArgList                                               # ExprMsgNameBlock
     | name PAREN_OPEN argList keyArgList? PAREN_CLOSE blockArgList?                             # ExprMsgDotNameArgs
     | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN PAREN_CLOSE blockArgList                       # ExprMsgKeyBlock
     | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN argList keyArgList? PAREN_CLOSE blockArgList?  # ExprMsgKeyArgs
     | name PAREN_OPEN performArgList keyArgList? PAREN_CLOSE                                    # ExprMsgNamePerform
     | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN performArgList keyArgList? PAREN_CLOSE         # ExprMsgKeyPerform
     | CLASSNAME SQUARE_OPEN arrayElems? SQUARE_CLOSE                                            # ExprMsgNewCollection
     | CLASSNAME blockArgList                                                                    # ExprMsgClassBlock
     | CLASSNAME PAREN_OPEN PAREN_CLOSE blockArgList?                                            # ExprMsgClass
     | CLASSNAME PAREN_OPEN keyArgList PAREN_CLOSE blockArgList?                                 # ExprMsgClassKeyArgs
     | CLASSNAME PAREN_OPEN argList keyArgList? PAREN_CLOSE blockArgList?                        # ExprMsgClassArgs
     | CLASSNAME PAREN_OPEN performArgList keyArgList? PAREN_CLOSE                               # ExprMsgClassPerform
     | expr DOT PAREN_OPEN keyArgList? PAREN_CLOSE blockArgList?                                 # ExprMsgDot
     | expr DOT name PAREN_OPEN keyArgList PAREN_CLOSE blockArgList?                             # ExprMsgDotNameKeyArgs
     | expr DOT PAREN_OPEN argList keyArgList? PAREN_CLOSE blockArgList?                         # ExprMsgDotArgs
     | expr DOT PAREN_OPEN performArgList keyArgList? PAREN_CLOSE                                # ExprMsgDotPerform
     | expr DOT name (PAREN_OPEN PAREN_CLOSE)? blockArgList?                                     # ExprMsgDotName
     | expr DOT name PAREN_OPEN argList keyArgList? PAREN_CLOSE blockArgList?                    # ExprMsgDotNameArgs
     | expr DOT name PAREN_OPEN performArgList keyArgList? PAREN_CLOSE                           # ExprMsgDotNamePerform
     ;

block : HASH? CURLY_OPEN argDecls? varDecls? body? CURLY_CLOSE ;

blockArgList : block+;

body : returnExpr
     | exprSeq returnExpr?
     ;

returnExpr : CARET expr SEMICOLON? ;

exprSeq : expr (SEMICOLON expr)*? SEMICOLON? ;

varDecls : (VAR varDefList SEMICOLON)+ ;

listComp : CURLY_OPEN COLON exprSeq COMMA qualifiers CURLY_CLOSE
         | CURLY_OPEN SEMICOLON exprSeq COMMA qualifiers CURLY_CLOSE
         ;

qualifiers : qualifier (COMMA qualifier)* ;

qualifier : name ARROW_LEFT exprSeq
          | name name ARROW_LEFT exprSeq
          | exprSeq
          | VAR name EQUALS exprSeq
          | COLON COLON exprSeq
          | COLON WHILE exprSeq
          ;

binopKey : binop
         | KEYWORD
         ;

binop : ARROW_LEFT
      | ASTERISK
      | EQUALS
      | GREATER_THAN
      | LESS_THAN
      | MINUS
      | PIPE
      | PLUS
      | READ_WRITE
      | BINOP
      ;

argList : exprSeq (COMMA exprSeq)* COMMA? ;

keyArgList : keyArg (COMMA keyArg)* COMMA? ;

keyArg : KEYWORD exprSeq ;

performArgList : (argList COMMA)? ASTERISK exprSeq ;

arrayElems : arrayElem (COMMA arrayElem)*? COMMA? ;

arrayElem : exprSeq
          | exprSeq COLON exprSeq
          | KEYWORD exprSeq
          ;

numericSeries : exprSeq (COMMA exprSeq)? DOT_DOT exprSeq?
              | DOT_DOT exprSeq
              ;

dictElements : dictElement (COMMA dictElement)* COMMA? ;

dictElement : exprSeq COLON exprSeq
            | KEYWORD exprSeq
            ;

adverb : DOT name
       | DOT integer
       | DOT PAREN_OPEN exprSeq PAREN_CLOSE
       ;

multiAssignVars : name (COMMA name)* (ELLIPSES name)? ;

pipeDefList : pipeDef (COMMA? pipeDef)* ;

pipeDef : name EQUALS? literal?
        | name EQUALS? PAREN_OPEN exprSeq PAREN_CLOSE
        ;

primitive : PRIMITIVE SEMICOLON? ;

classExtension  : PLUS CLASSNAME CURLY_OPEN methodDef* CURLY_CLOSE
                ;

interpreterCode : PAREN_OPEN varDecls+ body PAREN_CLOSE
                | varDecls+ body
                | body
                ;
