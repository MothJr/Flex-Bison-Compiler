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

#include "types.h"
#include "listing.h" 
#include "symbols.h"

extern char *yytext;
int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;
vector<Types> case_return;

int result; 
double *numParams;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL CASE TRUE FALSE IS WHEN

%token ADDOP MULOP RELOP REMOP NOTOP EXPOP ANDOP OROP 

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER REDUCE RETURNS 
%token <type> IF THEN ELSE ENDIF REAL ENDCASE OTHERS ARROW 

%type <type> body statement_ statement reductions expression relation term factor binary primary exponent unary 
case cases_ type parameter


%%

function:	
	function_header optional_variable body  ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ';' ;

optional_variable: 
	variable optional_variable |
	%empty ;

variable:
	IDENTIFIER ':' type IS statement_ {checkAssignment($3, $5, "Variable Initialization"); symbols.insert($1, $3);} |
	error ;

parameters:
	parameter optional_parameter ;

optional_parameter:
	optional_parameter ',' parameter |
	%empty ;

parameter:
	IDENTIFIER ':' type {if (symbols.find($1, $$)) 
							appendError(DUPLICATE_IDENTIFIER, $1);
						else 
							symbols.insert($1, $3);};

type:
	INTEGER {$$ = INT_TYPE;} | 
	REAL {$$ = REAL_TYPE;} | 
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement |
	error {$$ = MISMATCH;} ;
	
statement:
	expression ';' |
	REDUCE operator reductions ENDREDUCE ';' {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF ';' {$$ = checkIfThen($2, $4, $6);} |
	CASE expression IS cases_ OTHERS ARROW statement_ ENDCASE ';' {$$ = checkExpression($2); case_return.push_back($7);} ;

cases_:
	cases_ case {$$ = $2;} |
	%empty {$$ = NAN_TYPE;} ;
	
case: 
	WHEN INT_LITERAL ARROW statement_  {case_return.push_back($4);} ;
	
operator:
	OROP |
	ANDOP |
	RELOP |
	ADDOP |
	MULOP | REMOP 
	| EXPOP |
	NOTOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	%empty {$$ = INT_TYPE;} ;	
	    
expression:
	expression OROP binary {$$ = checkLogical($1, $3);} |
	binary ;

binary:
	binary ANDOP relation {$$ = checkLogical($1, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);} |
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = checkArithmetic($1, $3);} |
	factor REMOP exponent {$$ = checkArithmetic($1, $3);} |
	exponent ;

exponent:
	exponent EXPOP exponent {$$ = checkArithmetic($1, $3);} |
	unary ;
	
unary:
	NOTOP primary {$$ = checkNegation($2);} |
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
	numParams = new double[argc-1];

	

	firstLine();
	yyparse();

	if (lastLine() == 0)
		printf("Result = %d\n", result);

		for (int i = 1; i < argc; i++)
		{
			numParams[i-1] = atof(argv[i]);
			std::cout << argv[i] << std::endl;
		}

	return 0;
	
}
