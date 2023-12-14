/***************************************************************************
Scanner for the Mini language
***************************************************************************/

%{

#include <string.h>      
#include <stdlib.h>     
#include "Mini_Parser.tab.h" 
int yylinerror = 1;

#define TOKEN(t) (yylval.token = t)

%}     
           
DIGIT[0-9] 
ID[a-z][a-z0-9]*


%% 

'(\\.|''|[^'\n])*' |
\"(\\.|\"\"|[^"\n])*\" { yylval.strval = strdup(yytext); return STRING; }
'(\\.|[^'\n])*$ { yyerror("Unterminated string %s", yytext); }
\"(\\.|[^"\n])*$ { yyerror("Unterminated string %s", yytext); }



{DIGIT}+ { yylval.intval = atoi(yytext);  
        return (NUMBER); }

-?[0-9]+"."[0-9]* |
-?"."[0-9]+ |
-?[0-9]+E[-+]?[0-9]+ |
-?[0-9]+"."[0-9]*E[-+]?[0-9]+


"% "[ \t].*


program { return (PROGRAM); }
do { return(DO); }
else { return(ELSE); }
end { return(END); }
if { return(IF); }
begin { return(BEGN); }
integer { return(INTEGER); }
declare { return(DECLARE); }
read { return(READ); }
then { return(THEN); }
while { return(WHILE); }
write { return(WRITE); }
and { return(AND) ;}


":=" { return (ASSGNOP); }
"+"         { printf("[%d] - Linha %d: '+' encontrado\n", yylinerror++, yylinerror); return '+'; }
"-"         { printf("[%d] - Linha %d: '-' encontrado\n", yylinerror, yylinerror); return '-'; }
"*"         { printf("[%d] - Linha %d: '*' encontrado\n", yylinerror, yylinerror); return '*'; }
"/"         { printf("[%d] - Linha %d: '/' encontrado\n", yylinerror, yylinerror); return '/'; }
"%"         { printf("[%d] - Linha %d: '%%' encontrado\n", yylinerror, yylinerror); return MOD; }
">"         { printf("[%d] - Linha %d: '>' encontrado\n", yylinerror, yylinerror); return '>'; }
">="        { printf("[%d] - Linha %d: '>=' encontrado\n", yylinerror, yylinerror); return '>='; }
"<"         { printf("[%d] - Linha %d: '<' encontrado\n", yylinerror, yylinerror); return '<'; }
"<="        { printf("[%d] - Linha %d: '<=' encontrado\n", yylinerror, yylinerror); return '<='; }
"<>"        { printf("[%d] - Linha %d: '<>' encontrado\n", yylinerror, yylinerror); return '<>'; }
";"         { printf("[%d] - Linha %d: ';' encontrado\n", yylinerror, yylinerror); return ';'; }
":"         { printf("[%d] - Linha %d: ':' encontrado\n", yylinerror, yylinerror); return ':'; }
","         { printf("[%d] - Linha %d: ',' encontrado\n", yylinerror, yylinerror); return ','; }
"("         { printf("[%d] - Linha %d: '(' encontrado\n", yylinerror, yylinerror); return '('; }
")"         { printf("[%d] - Linha %d: ')' encontrado\n", yylinerror, yylinerror); return ')'; }



{ID}   {
        yylval.id = (char *)strdup(yytext);
        return (IDENTIFIER);
        }

[ \t\n]+ /* eat up whitespace */

"%"[^%\n]*"%"  ; /* Comentário começando com '%' e terminando com '%' */

.            { fprintf(stderr, "Erro na linha %d: Caractere não reconhecido: %c\n", yylinerror, yytext[0]); return yytext[0]; }

<<EOF>>      { return 0; }
%%


int yywrap(void){}
