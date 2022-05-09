   /* Tim McNeill
   Lexical Analyzer
   5 May 2022
   This file holds all lexemes and their assigned tokens 
   */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

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

{ws}		      { ECHO; }
{comment}	   { ECHO; nextLine();}
{line_comment}	{ ECHO; nextLine();}
{line}		   { ECHO; nextLine();}
{real_literal}	{ ECHO; yylval.value = atoi(yytext); return(REAL_LITERAL); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
"=>"	   { ECHO; yylval.oper = TO; return(ARROW);}
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"="		{ ECHO; yylval.oper = EQUALS; return(RELOP); }
"/="	   { ECHO; yylval.oper = ASSIGNQUOTIENT; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
">="	   { ECHO; yylval.oper = GREATEROREQUAL; return(RELOP); }
"<="	   { ECHO; yylval.oper = LESSOREQUAL; return(RELOP); }
"**"	   { ECHO; yylval.oper = EXPONENT; return(EXPOP); }
begin		   { ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
true	{ ECHO; yylval.value = atoi(yytext); return(BOOL_LITERAL); }
false	{ ECHO; yylval.value = atoi(yytext); return(BOOL_LITERAL); }
end		   { ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	   { ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		      { ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; yylval.oper = AND; return(ANDOP); }
case	{ ECHO; yylval.value = atoi(yytext); return(CASE); }
else	{ ECHO; return(ELSE); }
endcase	{ ECHO; yylval.value = atoi(yytext); return(ENDCASE); }
endif	{ ECHO; return(ENDIF); }
if	   { ECHO; return(IF); }
others	{ ECHO; yylval.value = atoi(yytext); return(OTHERS); }
real	{ ECHO; return(REAL); }
then	{ ECHO; return(THEN); }
when	{ ECHO; yylval.value = atoi(yytext); return(WHEN); }
or	   { ECHO; yylval.oper = OR; return(OROP); }
not	{ ECHO; yylval.oper = NOT; return(NOTOP); }
rem   { ECHO; yylval.oper = REMAINDER; return(REMOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

