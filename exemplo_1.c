int main(void){
 int X; int Y; 
 int Z; 
 printf("Variavel Monitoradas:Z ");
 
 Y = 2;
 X = 5;
 Z = Y;
 printf("Variavel Monitorada Alterada: Z");
 while(X){
 Z = Z + 1;
 printf("Variavel Monitorada Alterada: Z");

  X--;
}




 return 0;
}