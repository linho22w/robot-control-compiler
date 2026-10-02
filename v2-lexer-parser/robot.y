%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

	int nerros=0;
	int yylex();
	int yyerror(char *s);

	int PosicaoXR = 1, PosicaoYR = 1, direcaoR = 1;
	int PosicaoXP = 1, PosicaoYP = 1, direcaoP = 1;
	int PosicaoXC = 0, PosicaoYC = 0, ExisteC  = 0;	
	int EstadoP   = 1, ObjetoP   = 0;
	
	void ControloPinca();	
	void VIRAR(int a);
	void SHOW();
	void PosicaoPinca();
	const char * DIRECAOPINCA();
	const char * DIRECAOROBO();
	void ANDARR(int b);
	void RODARP(int c);
	void STRING();	
	void LARGAR_OBJETO();
	void PEGAR_OBJETO();
	void Criar_C(int d);
%}

%union{
char *id;
int inteiro;
char str;
}
%token <id>      DIREITA ESQUERDA ABRIR FECHAR INICIO FIM OUTRO ENTER COMECA ACABA VIRGULA

%token <inteiro> ANDAR RODAR OBJETO

%start inicio

%%

inicio:   INICIO ENTER COMECA ENTER objetos | erros;

objetos:  OBJETO   {Criar_C($1); ExisteC = 1;} VIRGULA ENTER comandos | comandos

comandos: DIREITA  { VIRAR(1); PosicaoPinca(); } VIRGULA  ENTER comandos
	| ESQUERDA { VIRAR(2); PosicaoPinca(); } VIRGULA ENTER comandos  
	| ANDAR    { ANDARR($1); PosicaoPinca(); } VIRGULA ENTER comandos 
	| ABRIR    { if(EstadoP == 0){printf("A pinca ja se encontra aberta, nao foi realizada a operacao  \n");}else{EstadoP = 0; LARGAR_OBJETO();}} VIRGULA ENTER comandos 
	| FECHAR   { if(EstadoP == 1){printf("A pinca ja se encontra fechada, nao foi realizada a operacao \n");}else{EstadoP = 1; PEGAR_OBJETO();} } VIRGULA ENTER comandos 
	| RODAR    { RODARP($1); ControloPinca(); PosicaoPinca();} VIRGULA ENTER comandos
	| fim
	| erros;

erros: OUTRO ENTER { nerros++; } comandos;
      
fim: ACABA    ENTER FIM      {printf("Houve %d erros no ficheiro. \n", nerros);SHOW();};
%%

int main()
{
	yyparse();
}

int yyerror(char *s)
{
nerros++;
}

void PEGAR_OBJETO()
{
	if(PosicaoXP == PosicaoXC && PosicaoYP == PosicaoYC){ ObjetoP = 1;} 
}

void LARGAR_OBJETO()
{
	if(ObjetoP == 1){
		PosicaoXC = PosicaoXP;
		PosicaoYC = PosicaoYP;
	
		ObjetoP = 0;
	}
}

void VIRAR(int a)
{
	if(a == 1){
		direcaoR++;
		direcaoP = direcaoP + 2;
		if(direcaoR == 5) {direcaoR = 1;}
		if(direcaoP == 9) {direcaoP = 1;}
		if(direcaoP == 10){direcaoP = 2;}
	}
	if(a == 2){
		direcaoR--;
		direcaoP = direcaoP - 2;
        	if(direcaoR == 0) {direcaoR = 4;}
		if(direcaoP == 0) {direcaoP = 8;}
		if(direcaoP == -1){direcaoP = 7;}
	}
}

void RODARP(int c)
{
	      if(c == 45 || c == -315){
		direcaoP = direcaoP + 1;
	}else if(c == 90 || c == -270){
	 	direcaoP = direcaoP + 2;
	}else if(c == 135 || c == -225) {
		direcaoP = direcaoP + 3;
	}else if(c == 180 || c == -180) {
                direcaoP = direcaoP + 4;
        }else if(c == 225 || c == -135) {
		direcaoP = direcaoP - 3;
        }else if(c == 270 || c == -90) {
                direcaoP = direcaoP - 2;
        }else if(c == 315 || c == -45) {
                direcaoP = direcaoP - 1;
        }else{
		printf("O comando introduzido nao altera a posicao da pinca.\n");
        }
}
	
void ANDARR(int b)
{
	if(direcaoR == 1){
        	PosicaoYR = PosicaoYR + b;
                if(PosicaoYR > 100){
                        printf("O robo nao pode sair da grelha de 100 x 100 \n");
                        printf("Erro no comando ANDAR(%d). Nao foi efetuado nenhuma operacao\n",b);
                	PosicaoYR = PosicaoYR - b;
                }
        }
        if(direcaoR == 2){
                PosicaoXR = PosicaoXR + b;
                if(PosicaoXR > 100){
                        printf("O robo nao pode sair da grelha de 100 x 100\n");
                        printf("Erro no comando ANDAR(%d). Nao foi efetuado nenhuma operacao\n",b);
        	        PosicaoXR = PosicaoXR - b;
                }
        }
        if(direcaoR == 3){
                PosicaoYR = PosicaoYR - b;
                if(PosicaoYR < 1){
                        printf("O robo nao pode sair da grelha de 100 x 100\n");
                        printf("Erro no comando ANDAR(%d). Nao foi efetuado nenhuma operacao\n",b);
                        PosicaoYR = PosicaoYR + b;
                }
        }
        if(direcaoR == 4){
                PosicaoXR = PosicaoXR - b;
                if(PosicaoXR < 1){
 			printf("O robo nao pode sair da grelha de 100 x 100\n");
                        printf("Erro no comando ANDAR(%d). Nao foi efetuado nenhuma operacao\n",b);
                        PosicaoXR = PosicaoXR + b;
                }
        }
}

const char * ESTADOP()
{
	if(EstadoP == 1){
		return "fechado";
	}else{
	 	return "aberto";
	}
}

void Criar_C(int d)
{

    	char str[7], x[7],y[7];
	sprintf(str, "%d", d);

   	if(str[0] == '2'){

		x[0] = str[2];
	}

	if(str[0] == '3'){

		x[0] = str[1];
		x[1] = str[2];
	}

	if(str[0] == '1'){

  		x[0] = str[0];
		x[1] = str[1];
		x[2] = str[2];
    	}	

    	y[0] = str[3];
	y[1] = str[4];
	y[2] = str[5];


    	PosicaoXC = atoi(x);
	PosicaoYC = atoi(y);
}

void SHOW()
{
	printf("O robo esta virado para %s, na posicao %d x %d \n", DIRECAOROBO(), PosicaoXR, PosicaoYR);
    	printf("A pinca esta virada para %s, na posicao %d x %d, no estado %s \n", DIRECAOPINCA(), PosicaoXP, PosicaoYP,ESTADOP());
	if(ExisteC == 1) {printf("A caixa esta na posicao %d x %d \n", PosicaoXC, PosicaoYC);}
}

const char * DIRECAOROBO()
{
	if(direcaoR == 1) {return "Norte";}
	if(direcaoR == 2) {return "Este";}
	if(direcaoR == 3) {return "Sul";}
	if(direcaoR == 4) {return "Oeste";}
}

const char * DIRECAOPINCA()
{

	if(direcaoP == 1) {return "Norte";}
        if(direcaoP == 2) {return "Nordeste";}
        if(direcaoP == 3) {return "Este";}
        if(direcaoP == 4) {return "Sudeste";}
        if(direcaoP == 5) {return "Sul";}
        if(direcaoP == 6) {return "Sudoeste";}
        if(direcaoP == 7) {return "Oeste";}
        if(direcaoP == 8) {return "Noroeste";}
	
}

void ControloPinca()
{
	if(direcaoP == 9 ) {direcaoP = 1;}
	if(direcaoP == 10) {direcaoP = 2;}
	if(direcaoP == 11) {direcaoP = 3;}
	if(direcaoP == 12) {direcaoP = 4;}
	if(direcaoP == 0 ) {direcaoP = 8;}
	if(direcaoP == -1) {direcaoP = 7;}
	if(direcaoP == -2) {direcaoP = 6;}

}

void PosicaoPinca()
{
	      if(direcaoP == 1){

		PosicaoYP = PosicaoYR + 1;
		PosicaoXP = PosicaoXR;

	}else if(direcaoP == 2){
		
		PosicaoYP = PosicaoYR + 1;
		PosicaoXP = PosicaoXR + 1;

	}else if(direcaoP == 3){
		
		PosicaoYP = PosicaoYR;
		PosicaoXP = PosicaoXR + 1;
       
	}else if(direcaoP == 4){

		PosicaoYP = PosicaoYR - 1;
		PosicaoXP = PosicaoXR + 1;

        }else if(direcaoP == 5){

		PosicaoYP = PosicaoYR - 1;
		PosicaoXP = PosicaoXR;

        }else if(direcaoP == 6){
		
		PosicaoYP = PosicaoYR - 1;
		PosicaoXP = PosicaoXR - 1;
	
        }else if(direcaoP == 7){

		PosicaoYP = PosicaoYR;
		PosicaoXP = PosicaoXR - 1;
		
        }else if(direcaoP == 8){
		
		PosicaoYP = PosicaoYR + 1;
	}
}
