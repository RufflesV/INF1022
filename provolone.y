%{
  #include <stdlib.h>
  #include <stdio.h>
  #include <string.h>
  #include "provolone.tab.h"
  int count=0;
  extern FILE *yyin;
  extern FILE *yyout;
  char *monitorar_var[15];
  
  int yylex();
%}
%union
 {
   char *str;
   int  num;
};

%type <str> programa varlist cmds cmd monitor_var;
%token <str> INICIO
%token<num> NUMBER
%token <str> MONITOR
%token <str> EXECUTE
%token <str> TERMINO
%token <str> ID
%token <str> ENQUANTO
%token <str> EVAL
%token <str> FIM
%token <str> FACA
%token <str> IF
%token <str> THEN
%token <num> PLUS
%token <str> ABRE_P
%token <str> FECHA_P
%token <str> ASSIGN
%token <str> ZERO
%token <str> ELSE
%token <str> MULT


%start programa
%%

programa: INICIO varlist monitor_var EXECUTE cmds TERMINO{ 
   rewind(yyout);
   fprintf(yyout,"int main(void){\n %s\n %s\n %s\n return 0;\n}",$2,$3,$5);
   printf("\nvalores:\n%s\n%s\n%s\n",$2,$3,$5);
   fclose(yyout);
   exit(1);

};
monitor_var: MONITOR varlist {
                      //Print no console
                      printf("\nVariáveis monitoradas:%s\n", $2);

                      char* monitoradas = (char*)malloc(strlen($2)+ 36);
                      strcat(monitoradas, $2);
                      strcat(monitoradas, "\n ");
                      strcat(monitoradas, "printf(");
                      strcat(monitoradas, "\"");
                      strcat(monitoradas, "Variavel Monitoradas:");
                      
                      //botando as variaveis na lista global antes de concatenar a monitoradas
                      int i = 0; //contador
                      char *separadores = " ;"; 
                      char *token;
                      token = strtok($2, separadores);
                      while (token != NULL) {
                          if (strcmp(token, "int") != 0) {
                              monitorar_var[i++] = token; // botando na lista se n for "int"
                          }
                          //para o proximo token
                          token = strtok(NULL, separadores);
                      }
                      
                      count = i; //colocando o a qnt de variaveis dentro de um contador global
                      /*
                      for (int j = 0; j < i; j++) {
                          printf("VARIAVEIS ARMAZENADAS:%s\n", monitorar_var[j]);
                      }
                      */
                      for(int q = 0; q < i; q++){
                          strcat(monitoradas, monitorar_var[q]);
                          strcat(monitoradas, " ");
                      }
                      strcat(monitoradas, "\"");
                      strcat(monitoradas, ");\n ");
                      $$ = monitoradas;
                      
                    };
varlist: varlist ID { 
                      char* entrada= (char*) malloc(strlen($1) + strlen($2) + 7);
                      strcpy(entrada, $1);
                      strcat(entrada,"int ");
                      strcat(entrada,$2);
                      strcat(entrada,"; "); 
                      
                      $$ = entrada;
                      
                    }
          | ID      { 
                      char* entrada = (char*)malloc(strlen($1) + 8);
                      strcpy(entrada,"int ");
                      strcat(entrada, $1);
                      strcat(entrada,"; ");
                      $$ = entrada;
                      
                    };
cmds: cmd cmds {
                char* commands = (char*) malloc(strlen($1)+strlen($2)+1);
                strcpy(commands,$1);
                strcat(commands,$2);
                strcat(commands,"\n");
                $$ = commands;
                
              }
      |cmd {
              $$=$1;
            };      
                  
cmd: ID ASSIGN ID {
                    
                    char* assign = (char*) malloc(strlen($1) + strlen($3) + 48);
                    strcpy(assign,$1);
                    strcat(assign," = ");
                    strcat(assign,$3);
                    strcat(assign,";\n ");
                    
                    //checar se está ou não na lista monitorada
                    for (int i = 0; i < count; i++) {
                      if (strcmp($1, monitorar_var[i]) == 0) {
                        strcat(assign, "printf(");
                        strcat(assign, "\"");
                        strcat(assign, "Variavel Monitorada Alterada: ");
                        strcat(assign, monitorar_var[i]);
                        strcat(assign, "\"");
                        strcat(assign, ");\n ");
                      }
                    }
                    $$ = assign;
                    
                    
                  }
      | ID PLUS ID {
                    char* plus = malloc(strlen($3) + 4);
                    strcpy(plus,$1);
                    strcat(plus," + ");
                    strcat(plus,$3);
                    strcat(plus,";\n ");
                    $$ = plus;  
                    
                  }
      | ID MULT ID {
                  char* mult = malloc(strlen($3) + 4);
                  strcpy(mult,$1);
                  strcat(mult," * ");
                  strcat(mult,$3);
                  strcat(mult,";\n ");
                  $$ = mult;    
                  
      
                  }
      | ZERO ABRE_P ID FECHA_P {
                    char* zera = malloc(strlen($3) + 8);
                    strcat(zera,$3);
                    strcat(zera," = 0;\n ");
                    $$ = zera;
                    
                  }
      
      | ENQUANTO ID FACA cmds FIM   {
                    char* while_cmd = malloc(strlen($2) + strlen($4) + strlen($2) + 64);
                    strcpy(while_cmd,"while(");
                    strcat(while_cmd,$2);
                    strcat(while_cmd,"){\n ");                         
                    strcat(while_cmd,$4);
                    strcat(while_cmd,"\n  ");
                    strcat(while_cmd,$2);
                    strcat(while_cmd,"--;\n");
                    //checar se está ou não na lista monitorada
                    for (int i = 0; i < count; i++) {
                      if (strcmp($2, monitorar_var[i]) == 0) {
                         strcat(while_cmd, "printf(");
                         strcat(while_cmd, "\"");
                         strcat(while_cmd, "Variavel Monitorada Alterada: ");
                         strcat(while_cmd, monitorar_var[i]);
                         strcat(while_cmd, "\"");
                         strcat(while_cmd,");\n");
                      }
                    }
                    strcat(while_cmd,"}\n");
                    $$ = while_cmd;
                    
                  }
      | IF ID THEN cmds FIM {
                    char* if_cmd = malloc(strlen($2)+strlen($4)+ 18);
                    strcpy(if_cmd,"if(");
                    strcat(if_cmd,$2);
                    strcat(if_cmd,"){\n ");
                    strcat(if_cmd,$4);
                    strcat(if_cmd,"\n}\n");
                    $$ = if_cmd;
                    
                  }
      | IF ID THEN cmds ELSE cmds FIM {
                    char* if_else_cmd = malloc(strlen($2)+strlen($4)+strlen($6)+28);
                    strcpy(if_else_cmd,"if(");
                    strcat(if_else_cmd,$2);
                    strcat(if_else_cmd,"){\n ");
                    strcat(if_else_cmd,$4);
                    strcat(if_else_cmd,"\n}\n else{\n ");
                    strcat(if_else_cmd,$6);
                    strcat(if_else_cmd,"\n}\n");  
                    $$ = if_else_cmd;
                    
                  }
      | ID ASSIGN ID PLUS ID {
                    char* assign_plus = malloc(strlen($1) + strlen($3) + strlen($5) + 40);
                    strcpy(assign_plus,$1);
                    strcat(assign_plus," = ");
                    strcat(assign_plus,$3);
                    strcat(assign_plus," + ");
                    strcat(assign_plus,$5);
                    strcat(assign_plus,";\n ");
                    //checar se está ou não na lista monitorada
                    for (int i = 0; i < count; i++) {
                      if (strcmp($1, monitorar_var[i]) == 0) {
                        strcat(assign_plus, "printf(");
                        strcat(assign_plus, "\"");
                        strcat(assign_plus, "Variavel Monitorada Alterada: ");
                        strcat(assign_plus, monitorar_var[i]);
                        strcat(assign_plus, "\"");
                        strcat(assign_plus, ");\n");
                      }
                    }
                    $$ = assign_plus;    
                }
      | ID ASSIGN ID MULT ID {
                    char* assign_mult = malloc(strlen($1) + strlen($3) + strlen($5) + 40);
                    strcpy(assign_mult,$1);
                    strcat(assign_mult," = ");
                    strcat(assign_mult,$3);
                    strcat(assign_mult," * ");
                    strcat(assign_mult,$5);
                    strcat(assign_mult,";\n ");
                    //checar se está ou não na lista monitorada
                    for (int i = 0; i < count; i++) {
                      if (strcmp($1, monitorar_var[i]) == 0) {
                         strcat(assign_mult, "printf(");
                         strcat(assign_mult, "\"");
                         strcat(assign_mult, "Variavel Monitorada Alterada: ");
                         strcat(assign_mult, monitorar_var[i]);
                         strcat(assign_mult, "\"");
                         strcat(assign_mult,");\n");
                      }
                    }
                    $$ = assign_mult;  
                    
                }
      | EVAL ABRE_P ID ID cmds FECHA_P {
                    char* eval = malloc(strlen($3)+strlen($4)+strlen($5) + 64); 
                    strcpy(eval,"while(");
                    strcat(eval,$3);
                    strcat(eval,"!=");
                    strcat(eval,$4);
                    strcat(eval,"){\n"); 
                    strcat(eval," ");
                    strcat(eval,$5); 
                    strcat(eval,$3); 
                    strcat(eval,"--;\n");
                    //checar se está ou não na lista monitorada
                    for (int i = 0; i < count; i++) {
                      if (strcmp($3, monitorar_var[i]) == 0) {
                         strcat(eval, "printf(");
                         strcat(eval, "\"");
                         strcat(eval, "Variavel Monitorada Alterada: ");
                         strcat(eval, monitorar_var[i]);
                         strcat(eval, "\"");
                         strcat(eval,");\n");
                      }
                    }
                    strcat(eval,"}\n");
                    $$ = eval;
                    
                };
                  
%%



int main(int argc, char *argv[]){

  yyin = fopen(argv[1],"r");
  if(yyin==NULL){
    printf("ERROR: Insira um arquivo provolone como parâmetro.");
    exit(1);
  }

  char* arq_nome = (char*) malloc(strlen(argv[0]) + 3); 
  strcpy(arq_nome,argv[2]);
  yyout = fopen(arq_nome,"w");
  
  yyparse();
  fclose(yyin);
  free(arq_nome);
  return 0;
}

yyerror(const char *s) {
  printf("ERROR");

  return 0;
}