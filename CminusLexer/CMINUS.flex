/******************************/
/* File: tiny.flex            */
/* Lex specification for TINY */
/******************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
#include "util.c"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
comment     "/*"[^"*"]*"*/"|"//".*
newline     \n
whitespace  [ \t]+

/* This tells flex to read only one input file */
%option noyywrap

%%

"if"             {return IF;}
"void"           {return VOID;}
"return"         {return RETURN;}
"else"           {return ELSE;}
"while"          {return WHILE;}
"input"          {return READ;}
"write"          {return WRITE;}
"int"            {return INT_DT;}
"="              {return ASSIGN;}
"=="             {return EQUAL;}
"!="             {return NOTEQUAL;}
"<"              {return LT;}
"<="             {return LTEQUAL;}
">"              {return GT;}
">="             {return GTEQUAL;}
"+"              {return PLUS;}
"-"              {return MINUS;}
"*"              {return MUL;}
"/"              {return OVER;}
"("              {return LPAREN;}
")"              {return RPAREN;}
"{"              {return LCURLY;}
"}"              {return LCURLY;}
"["              {return LBRAKET;}
"]"              {return RBRAKET;}
";"              {return SEMICOLON;}
","              {return COMMA;}
{number}         {return NUMBER;}
{identifier}     {return IDENTIFIER;}
{newline}        {lineno++;}
{comment}        {/* skip comments */}
{whitespace}     {/* skip whitespace */}
.                {return ERROR;}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = fopen("main.cm", "r+");
    yyout = fopen("result.txt","w+");
    listing = yyout;
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  
    fprintf(listing,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  
  return currentToken;
}

int main()
{
	printf("welcome to the flex scanner: ");
	while(getToken())
	{
		printf("a new token has been detected...\n");
	}
	return 1;
}

