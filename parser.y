/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL
%token REAL_LTERAL
%token BOOLEAN_LITERAL

%token ADDOP MULOP RELOP ANDOP REMOP EXPOP OROP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%%

function:	
	function_header '{' variable '}' body ;
	
function_header:	
	FUNCTION IDENTIFIER '[' parameters ']' RETURNS type ';' ;

optional_variable:
	variable |
	;

variable:
	IDENTIFIER ':' type IS statement_ ;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression ';' |
	REDUCE operator '{' reductions '}' ENDREDUCE ';' |
	CASE expression IS '{' case '}' OTHERS ARROW satement ENDCASE ';' ;

operator:
	ADDOP |
	MULOP ;

case: 
	WHEN INT_LITERAL ARROW statement

reductions:
	reductions statement_ |
	;
		    
expression:
	'(' expression ')' |
	expression binary_operator expression |
	NOTOP expression |
	INT_LITERAL | REAL_LTERAL | BOOLEAN_LITERAL |
	IDENTIFIER

relation:
	relation RELOP term |
	term ;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP primary |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL | 
	IDENTIFIER ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
