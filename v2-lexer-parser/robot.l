%{
#include "robot.tab.h"
char str[6];
int NumV;
void String();
void StringO();
%}

%option nounput
%option noinput
%option noyywrap

%x C_NUM

%%

BEGIN 				return INICIO;

END				return FIM; 

VIRAR-DIREITA  			return DIREITA;

VIRAR-ESQUERDA 			return ESQUERDA;

ANDAR\((100|[1-9][0-9]|[1-9])\) String(); yylval.inteiro=NumV; return ANDAR; //Vai a funcao string, insere o valor que esta nos ( ) e retorna ANDAR

"PINCA(" BEGIN(C_NUM);
<C_NUM>"ABRIR"   		return ABRIR;
<C_NUM>"FECHAR"  		return FECHAR;                                
<C_NUM>")" BEGIN(INITIAL);

RODAR\(\-?(3(60|15)|2(25|70)|1(35|80)|45|90|0)\) { String(); yylval.inteiro=NumV; return RODAR;}//Vai a funcao string, insere o valor que esta nos ( ) e retorna RODAR

INIT-OBJETO\((101|100|[1-9]?[0-9]),(101|100|[1-9]?[0-9])\) { StringO(); yylval.inteiro=atoi(str); return OBJETO;}


"{"		return COMECA;

"}"		return ACABA;

","		return VIRGULA;

. 		return OUTRO;
		
\n		return ENTER;
		 
EOF		return 0; 

%%

void String()
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

void StringO()
{		
	if( yytext[13] == ','){					
		
		str[0] = '2';
		str[1] = '0';
		str[2] = yytext[12];

		if( yytext[15] == ')'){ 			 
		
		    	str[3] = '0';
			str[4] = '0';
			str[5] = yytext[14];

		}else if( yytext[16] == ')'){	

			str[3] = '0';
			str[4] = yytext[14];
			str[5] = yytext[15];

		}else if( yytext[17] == ')'){			
		
			str[3] = yytext[14];
			str[4] = yytext[15];
			str[5] = yytext[16];
			
		}	
	}else if( yytext[14] == ','){

		str[0] = '3';
		str[1] = yytext[12];
		str[2] = yytext[13];

                if( yytext[16] == ')'){                         
	
			str[3] = '0';
			str[4] = '0';
			str[5] = yytext[15];
	
                }else if( yytext[17] == ')'){ 

			str[3] = '0';
			str[4] = yytext[15];
			str[5] = yytext[16];
	
                }else if( yytext[18] == ')'){ 

			str[3] = yytext[15];
			str[4] = yytext[16];
			str[5] = yytext[17];

	        }

        }else if( yytext[15] == ','){         

		str[0] = yytext[12];
        	str[1] = yytext[13];
		str[2] = yytext[14];

		if( yytext[17] == ')'){             
			
			str[3] = '0';
			str[4] = '0';
			str[5] = yytext[16];	

        	}else if( yytext[18] == ')'){       
			
			str[3] = '0';
			str[4] = yytext[16];
			str[5] = yytext[17];

        	}else if( yytext[19] == ')'){
		
			str[3] = yytext[16];
			str[4] = yytext[17];
			str[5] = yytext[18];
		}
	}	
}
