   /* Tim McNeill
   Syntactical Analyzer
   5 May 2022
    
   */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cmath>
#include <math.h>

using namespace std;

#include "listing.h" 
#include "values.h"
#include "symbols.h"

extern char *yytext;
int yylex();
void yyerror(const char* message);

Symbols<int> symbols;

int result; 
int *numParams;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	int value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL CASE TRUE FALSE IS WHEN 

%token <oper> ADDOP MULOP RELOP REMOP NOTOP EXPOP ANDOP OROP 

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER REDUCE RETURNS 
%token IF THEN ELSE ENDIF REAL ENDCASE OTHERS ARROW 

%type <value> body statement_ statement reductions expression relation term factor binary primary exponent unary
				case optional_cases cases_
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ';' ;

optional_variable: 
	variable optional_variable |
	%empty ;

variable:
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} |
	error ;

parameters:
	parameter optional_parameter ;

optional_parameter:
	optional_parameter ',' parameter |
	%empty ;

parameter:
	IDENTIFIER ':' type {symbols.insert($1, numParams[0]);};

type:
	INTEGER | 
	REAL | 
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement |
	error {$$ = 0;} ;
	
statement:
	expression ';' |
	REDUCE operator reductions ENDREDUCE ';' {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF ';' {$$ = ($2) ? $4 : $6;} |
	CASE expression IS cases_ OTHERS ARROW statement_ ENDCASE ';' {$$ = $<value>4 == $1 ? $4 : $7;} ;

cases_:
	cases_ optional_cases {$$ = $<value>1 == $1 ? $1 : $2;} |
	%empty {$$ = NAN;} ;

optional_cases:
	case |
	error ';' {$$ = 0;} ;

case: 
	WHEN INT_LITERAL ARROW statement_ {$$ = $<value>-2 == $2 ? $4 : NAN;} ;
	
operator:
	OROP |
	ANDOP |
	RELOP |
	ADDOP |
	MULOP | REMOP 
	| EXPOP |
	NOTOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	%empty {$$ = $<oper>0 == ADD ? 0 : 1;} ;	
	    
expression:
	expression OROP binary {$$ = $1 || $3;} |
	binary ;

binary:
	binary ANDOP relation {$$ = $1 && $3;} |
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	factor REMOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	exponent ;

exponent:
	unary |
	exponent EXPOP exponent {$$ = pow($1, $3);} ;
	
unary:
	NOTOP primary {$$ = !$2;} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%


void yyerror(const char* message)
{
	appendError(SYNTAX, message);
	
}

int main(int argc, char *argv[])
{
	numParams = new int[argc-1];

	for (int i = 1; i < argc; ++i)
	{
		numParams[i-1] = atof(argv[i]);
	}

	firstLine();
	yyparse();

	if (lastLine() == 0)
		printf("Result = %d\n", result);
	
	return 0;
	
}
