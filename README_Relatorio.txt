Aluno: João Pedro de Arruda Raffo
Matrícula: 2010653

O QUE FOI IMPLEMENTADO:

Foi implementado um analisador sintático para a linguagem Provol-One. Ela compila programas escritos em Provol-One para a linguagem C, produzindo um arquivo .C com saída.
Sequências de Comando(cmds) como ENQUANTO id FACA cmds FIM, IF-THEN, IF-THEN-ELSE, EVAL(num1,num2,cmds), A+B, A*B, ZERO(A) também foram implementadas. A funcionalidade referente ao não terminal MONITOR também foi implementado, porém o enunciado estava vago sobre se era necessário imprimir no console a variável(descrito em MONITOR) e o valor associado a esta, logo realizei apenas a impressão da variável quando ela é declarada ou alterada.
Mudanças na gramática foram realizadas, podendo se consultar mais a frente.
Além dos arquivos necessários para a execução, foi realizado testes do analisador sintático com os exemplos fornecidos no enunciado. Os testes foram realizados na versão ".txt", porém também há os arquivos ".Provol" dentro do documento. Os resultados destes testes são os arquivos "exemplo_x.C", sendo x o numero que identifica o exemplo.

O QUE FUNCIONA:

A gramática de 'programa' teve que ser alterada para "INICIO varlist monitor_var(um não terminal criado) EXECUTE cmds TERMINO".
Operações de soma, multiplicação, atribuição(=) com variável como "Z=2", EVAL, ZERO(), os IFs, os loops e a impressão das variaveis dentro do MONITOR funcionaram, porém vale ressaltar novamente que o valor das variaveis do MONITOR não são armazenadas, logo não sendo atualizadas para as impressões
Dos exemplos fornecidos, o exemplo 1 funcionou de forma adequada. No exemplo 2, foi necessário realizar uma mudança no texto, pois não havia o FIM na penultima linha, que sinalizaria o final do IF-THEN-ELSE, mas tirando isso rodou perfeitamente. O exemplo 3 foi modificado, será explicado mais a frente o motivo, porém após a modificação rodou perfeitamente.

O QUE NÃO FUNCIONA:

Ao realizar o comando "gcc -o parser provolone.tab.c lex.yy.c -lfl" alguns avisos aparecem. O primeir avisa sobre a declaração implícita de "yyerror"(linha 1477 do arquivo provolone.tab.c) e o segundo sobre o retorno default do "yyerror" ser inteiro(linha 309 do arquivo provolone.y).
Linhas como "Z = EVAL(X, L, Z=Z*L)" do exemplo 3 não funcionaram, necessitando serem retiradas e substituídas por "EVAL(X, L, Z=Z*L)".
Há situações que um caractere "fantasma" é impresso e é levado ao arquivo.c, sendo este geralmente um "a" ou um "misterioso"(não estar sendo renderizado). A razão desta falha é por conta dos espaços em branco concatenados. Ele não foi detectado nos testes finais, porém é válido avisar sobre.
Testes/arquivos muito longos necessitarão de maior alocação de memória, estou incerto se o estado atual do código consegue prevenir problemas de "buffer overflow".

QUAIS OS TESTES UTILIZADOS:

Foi realizado diversos testes, foi fornecido os exemplos 1,2 e 3 no documento.
Lembrando que tanto o arquivo de exemplo 2 e 3 foram modificados, por razões especificadas anteriormente.

COMO EXECUTAR

É necessário rodar os seguintes comandos de linha:
-flex lexer.l(processar arquivos de definição de lexers)
-bison -d -t provolone.y(processar um arquivo de definição de gramática com Bison)
-gcc -o parser provolone.tab.c lex.yy.c -lfl(compilar os arquivos C gerados pelo Bsion e pelo Flex, criando o executável parser)
-./parser (arquivo .Provol ou .txt) (arquivo.c de output)
-(opcional) yacc -v provolone.y

GRAMÁTICA:
A gramática ficou bem similar a proposta original, porém modificações tiveram que ser feitas. 
Para demonstrar a gramática foi utilizado o seguinte comando: "yacc -v provolone.y"
Assim, é possível visualizar os estados do parser, regras da gramática e as tabelas de análise atráves do arquivo "y.output"(fornecido no documento)

A gramática foi tirado do arquivo y.output:
0 $accept: programa $end

    1 programa: INICIO varlist monitor_var EXECUTE cmds TERMINO

    2 monitor_var: MONITOR varlist

    3 varlist: varlist ID
    4        | ID

    5 cmds: cmd cmds
    6     | cmd

    7 cmd: ID ASSIGN ID
    8    | ID PLUS ID
    9    | ID MULT ID
   10    | ZERO ABRE_P ID FECHA_P
   11    | ENQUANTO ID FACA cmds FIM
   12    | IF ID THEN cmds FIM
   13    | IF ID THEN cmds ELSE cmds FIM
   14    | ID ASSIGN ID PLUS ID
   15    | ID ASSIGN ID MULT ID
   16    | EVAL ABRE_P ID ID cmds FECHA_P

ALTERAÇÕES NA GRAMÁTICA:
Foi adicionado o não terminal "monitor_var" para substituir "MONITOR varlist".
O terminal "cmd" foi expandido para além da "tabela" da gramática da página 2 do documento do Trabalho(a proposta do trabalho).
Segue o que foi adicionado: "id + id", "id * id", "Zero(id)", "If id Then cmds Else cmds Fim", "id = id + id",
"id = id * id", "eval(id,id,cmds)" e "If id Then cmds Fim".

