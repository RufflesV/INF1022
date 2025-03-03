%{
  #include "provolone.tab.h"
%}

%%
FIM     	return(FIM);
TERMINO return(TERMINO);
MONITOR return(MONITOR);
INICIO    return(INICIO);
EVAL return(EVAL);
ENQUANTO    return (ENQUANTO);
FACA        return(FACA);
IF          return(IF);
THEN      return(THEN);
ELSE       return(ELSE);
EXECUTE return(EXECUTE);
ZERO return (ZERO);
[a-zA-Z0-9]+ {yylval.str=strdup(yytext); return ID;}
"+" return (PLUS);
"=" return(ASSIGN);
"(" return (ABRE_P);
")" return (FECHA_P); 
"*" return (MULT);
\n
,
[ \t]+ 
.
%%


int yywrap(void) {
    return 1;  // Indica que a análise deve ser encerrada
}