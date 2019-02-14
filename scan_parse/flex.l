%{
#include <stdio.h>
#include "y.tab.h"S
int lineNo = 0;
int linePos = 0;
%}

NUMBER      0|[1-9][0-9]*
ID          [a-zA-Z][a-zA-Z0-9_]*

%option noyywrap
%x COMMENT ONELINECOMMENT
%%
<INITIAL>"+"    { return "+";}
<INITIAL>"-"    { return "-";}
<INITIAL>"*"    { return "*";}
<INITIAL>"/"    { return "/";}
<INITIAL>"=="   { return "==";}
<INITIAL>"!="   { return "!=";}
<INITIAL>"<"    { return "<";}
<INITIAL>">"    { return ">";}
<INITIAL>"<="   { return "<=";}
<INITIAL>">="   { return ">=";}
<INITIAL>"&&"   { return "&&";}
<INITIAL>"||"   { return "||";}
<INITIAL>"("    { return "(";}
<INITIAL>")"    { return ")";}

<INITIAL>ID     { /*yylval.stringconst = (char *) malloc(strlen(yytext)+1);
                    sprintf(yylval.stringconst, "%s", yytext);
                    return tID;*/}

<INITIAL>NUMBER { yylval.unum = atoi(yytext);
                    return tINT;}

<INITIAL>"(*"                       { BEGIN COMMENT;}
<INITIAL>#                          { BEGIN ONELINECOMMENT;}
<INITIAL>\n                         { lineNo++;}
<INITIAL>.                          /*TODO errors*/

<COMMENT>"*)"                       { BEGIN INITIAL;}
<COMMENT>\n                         { lineNo++;}
<COMMENT>.                          { /*ignore*/}

<ONELINECOMMENT>\n                  { lineNo++; BEGIN INITIAL;}
<ONELINECOMMENT>.                   { /*ignore*/}
%%