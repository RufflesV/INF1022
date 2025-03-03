int main(void){
 int X; int Y; int B; 
 int Z; 
 printf("Variavel Monitoradas:Z ");
 
 X = 5;
 Y = 2;
 B = 0;
 while(X!=Y){
 if(B){
 Z = Z + 2;
 printf("Variavel Monitorada Alterada: Z");

}
 else{
 Z = Z + 1;
 printf("Variavel Monitorada Alterada: Z");

}
X--;
}




 return 0;
}