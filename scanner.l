/* Compiler Theory and Design */
   /* Tim McNeill */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"
#include "parser.tab.h"

%}

%option noyywrap


ws		[ \t\r]+
comment		\-\-.*\n
line_comment  \/\/.*\n
line		[\n]
id		[A-Za-z]([_]?[A-Za-z0-9])*
digit		[0-9]
int		{digit}+
punc		[\(\),:;]
real_literal	[0-9]+\.[0-9]*([e|E]([\+|\-][0-9]+))?
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line_comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
{real_literal}	{ ECHO; return(REAL_LITERAL); }
"<"		{ ECHO; return(RELOP); }
"=>"	{ ECHO; return(ARROW);}
"+"		{ ECHO; return(ADDOP); }
"-"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"/"		{ ECHO; return(MULOP); }
"="		{ ECHO; return(RELOP); }
"/="	{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="	{ ECHO; return(RELOP); }
"<="	{ ECHO; return(RELOP); }
"* *"	{ ECHO; return(REPOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
true	{ ECHO; return(BOOL_LITERAL); }
false	{ ECHO; return(BOOL_LITERAL); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
case	{ ECHO; return(CASE); }
else	{ ECHO; return(ELSE); }
endcase	{ ECHO; return(ENDCASE); }
endif	{ ECHO; return(ENDIF); }
if	{ ECHO; return(IF); }
others	{ ECHO; return(OTHERS); }
real	{ ECHO; return(REAL); }
then	{ ECHO; return(THEN); }
when	{ ECHO; return(WHEN); }
or	{ ECHO; return(OROP); }
not	{ ECHO; return(NOTOP); }
rem { ECHO; return(REMOP); }
{id}		{ ECHO; return(IDENTIFIER);}
{int}		{ ECHO; return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

