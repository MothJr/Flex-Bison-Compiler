/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>

using namespace std;

#include "listing.h" 


extern char *yytext;
int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL
%token REAL_LITERAL
%token BOOL_LITERAL
%token OROP
%token ANDOP
%token RELOP REMOP NOTOP REPOP
%token ADDOP
%token MULOP
%token EXPOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS 
%token IF THEN WHEN ELSE ENDIF CASE OTHERS ARROW ENDCASE REAL  

%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameter RETURNS type ';' |
	error ;

optional_variable: 
	variable optional_variable |
	%empty ;

variable:
	IDENTIFIER ':' type IS statement_ |
	error ;

optional_parameter:
	optional_parameter RETURNS type ';' |
	parameter ;	

parameter:
	IDENTIFIER ':' type |
	%empty ;

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
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS optional_cases OTHERS ARROW statement_ ENDCASE ;

operator:
	ADDOP |
	MULOP REMOP |
	EXPOP ;

optional_cases:
	case optional_cases |
	%empty ;

case: 
	WHEN INT_LITERAL ARROW statement_ | 
	error ;

reductions:
	reductions statement_ |
	%empty ;
		    
expression:
	expression ANDOP relation |
	expression_ ;

expression_:
	expression_ OROP relation |
	relation ;

relation:
	relation RELOP term |
	term ;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP primary |
	factor REMOP |
	exponent ;

exponent:
	factor EXPOP notion |
	notion ;

notion:
	notion NOTOP primary |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
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

	
	// FILE *file = fopen("lexemes.txt", "wa"); 
	// int token = yylex();
	// while (token)
	// {
	// 	fprintf(file, "%d %s\n", token, yytext);
	// 	token = yylex();
	// }
	//yylex();
	// fclose(file);
	
}
