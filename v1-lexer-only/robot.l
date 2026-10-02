%option noyywrap
%x C_NUM
%{
	int  PosicaoY = 1, PosicaoX = 1, direcao = 1, PosicaoPinca = 1, EstadoPinca = 2, NumV = 0;
	void StringAndar();
	void StringRodar();
	void Andar();
	void ShowError();
	void Rodar();
	void ControloPinca();
%}
%%
VIRAR-DIREITA 	{
			direcao++;
			PosicaoPinca = PosicaoPinca + 2;
			if(direcao == 5) {direcao = 1;}
			if(PosicaoPinca == 9){PosicaoPinca = 1;}
			if(PosicaoPinca == 10){PosicaoPinca = 2;}
		}	

VIRAR-ESQUERDA	{
			direcao--;
			PosicaoPinca = PosicaoPinca - 2;
        		if(direcao == 0) {direcao = 4;}
			if(PosicaoPinca == 0){PosicaoPinca = 8;}
			if(PosicaoPinca == -1){PosicaoPinca = 7;}
		}
ANDAR\((100|[1-9][0-9]|[1-9])\) { StringAndar(); Andar();}

"PINCA(" BEGIN(C_NUM);
<C_NUM>"ABRIR"  { if(EstadoPinca != 1) { EstadoPinca = 1;}else{ShowError();}}
<C_NUM>"FECHAR" { if(EstadoPinca != 2) { EstadoPinca = 2;}else{ShowError();}}                                
<C_NUM>")" BEGIN(INITIAL);

RODAR\(\-?(3(60|15)|2(25|70)|1(35|80)|45|90|0)\) { StringRodar(); Rodar(); ControloPinca();}

. 		{
		
		}

\n		{

		}

EOF		{
		
		}
		
%%

void StringAndar()
{
	char t[4];
	if(yytext[7] == ')'){
		t[0] = yytext[6]; 
	}else if(yytext[8] == ')'){
		t[0] = yytext[6];
		t[1] = yytext[7];
	}else if(yytext[9] == ')'){
		t[0] = yytext[6];
                t[1] = yytext[7];
		t[2] = yytext[8];		
	}
	NumV = atoi(t);
}
void StringRodar()
{
	char a[4]="";
	int i= 0;
	if(yytext[6] == '-'){
		a[0] = yytext[6];
		i = 1;
	}
	if(yytext[7+i] == ')'){
                a[0+i] = yytext[6+i];
        }else if(yytext[8+i] == ')'){
                a[0+i] = yytext[6+i];
                a[1+i] = yytext[7+i];
	}else if(yytext[9+i] == ')'){
                a[0+i] = yytext[6+i];
                a[1+i] = yytext[7+i];
                a[2+i] = yytext[8+i];
        }
        NumV = atoi(a);
	
}

void Rodar()
{
	      if(NumV == 45 || NumV == -315){
		PosicaoPinca = PosicaoPinca + 1;
	}else if(NumV == 90 || NumV == -270){
	 	PosicaoPinca = PosicaoPinca + 2;
	}else if(NumV == 135 || NumV == -225) {
		PosicaoPinca = PosicaoPinca + 3;
	}else if(NumV == 180 || NumV == -180) {
                PosicaoPinca = PosicaoPinca + 4;
        }else if(NumV == 225 || NumV == -135) {
		PosicaoPinca = PosicaoPinca - 3;
        }else if(NumV == 270 || NumV == -90) {
                PosicaoPinca = PosicaoPinca - 2;
        }else if(NumV == 315 || NumV == -45) {
                PosicaoPinca = PosicaoPinca - 1;
        }else{
		printf("O comando introduzido nao altera a posicao da pinca.\n");
                ShowError();
        }
}

void ControloPinca()
{
	if(PosicaoPinca == 9 ) {PosicaoPinca = 1;}
	if(PosicaoPinca == 10) {PosicaoPinca = 2;}
	if(PosicaoPinca == 11) {PosicaoPinca = 3;}
	if(PosicaoPinca == 12) {PosicaoPinca = 4;}
	if(PosicaoPinca == 0 ) {PosicaoPinca = 8;}
	if(PosicaoPinca == -1) {PosicaoPinca = 7;}
	if(PosicaoPinca == -2) {PosicaoPinca = 6;}
	
}

void Andar()
{
        if(direcao == 1){
        	PosicaoY = PosicaoY + NumV;
                if(PosicaoY > 100){
                        printf("O robo nao pode sair da grelha de 100 x 100 \n");
                        printf("Erro no comando %s. Nao foi efetuado nenhuma operacao\n",yytext);
                	PosicaoY = PosicaoY - NumV;
                }
        }
        if(direcao == 2){
                PosicaoX = PosicaoX + NumV;
                if(PosicaoX > 100){
                        printf("O robo nao pode sair da grelha de 100 x 100\n");
                        printf("Erro no comando %s. Nao foi efetuado nenhuma operacao\n",yytext);
        	        PosicaoX = PosicaoX - NumV;
                }
        }
        if(direcao == 3){
                PosicaoY = PosicaoY - NumV;
                if(PosicaoY < 1){
                        printf("O robo nao pode sair da grelha de 100 x 100\n");
                        printf("Erro no comando %s. Nao foi efetuado nenhuma operacao\n",yytext);
                        PosicaoY = PosicaoY + NumV;
                }
        }
        if(direcao == 4){
                PosicaoX = PosicaoX - NumV;
                if(PosicaoX < 1){
 			printf("O robo nao pode sair da grelha de 100 x 100\n");
                        printf("Erro no comando %s. Nao foi efetuado nenhuma operacao\n",yytext);
                        PosicaoX = PosicaoX + NumV;
                }
        }
}

void ShowError()
{
	printf("Erro no comando %s. Nao foi efetuado nenhuma operacao\n", yytext);	
}

void ShowPosicaoPinca()
{
	if(PosicaoPinca == 1) {printf("A pinca esta virada para Norte		\n");}
        if(PosicaoPinca == 2) {printf("A pinca esta virada para Nordeste	\n");}
        if(PosicaoPinca == 3) {printf("A pinca esta virada para Este		\n");}
        if(PosicaoPinca == 4) {printf("A pinca esta virada para Sudeste		\n");}
        if(PosicaoPinca == 5) {printf("A pinca esta virada para Sul		\n");}
        if(PosicaoPinca == 6) {printf("A pinca esta virada para Sudoeste	\n");}
        if(PosicaoPinca == 7) {printf("A pinca esta virada para Oeste		\n");}
        if(PosicaoPinca == 8) {printf("A pinca esta virada para Noroeste	\n");}
}

void Showdirecao()
{
	if(direcao == 1) {printf("O Robo esta virado para Norte	\n");}
	if(direcao == 2) {printf("O Robo esta virado para Este	\n");}
	if(direcao == 3) {printf("O Robo esta virado para Sul	\n");}
	if(direcao == 4) {printf("O Robo esta virado para Oeste	\n");}
}

void ShowEstadoPinca()
{
	if(EstadoPinca == 2) {
		printf("A pinca esta fechada\n");
	}else{
		printf("A pinca esta Aberta\n");
	}
}
void ShowPosicao()
{
	printf("O robo esta na posicao %d x %d \n", PosicaoX, PosicaoY);
}

int main()
{
	yylex() ;
	ShowPosicao();
	Showdirecao();
	ShowPosicaoPinca();	
	ShowEstadoPinca();
}

