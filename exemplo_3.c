int main(void){
 int X; int Y; int L; 
 int Z; 
 printf("Variavel Monitoradas:Z ");
 
 Z = 0;
 X = 5;
 Y = 0;
 L = 1;
 if(Y){
 while(X!=L){
 Z = Z * L;
 printf("Variavel Monitorada Alterada: Z");
X--;
}

}
 else{
 while(X!=L){
 Z = Z * X;
 printf("Variavel Monitorada Alterada: Z");
X--;
}

}





 return 0;
}