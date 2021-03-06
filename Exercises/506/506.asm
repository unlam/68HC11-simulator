			ORG $0000			; s = n1 + n2 + n3 + ... + nn / Datos: n1, nn y s
S			RMB	2				; LOAD 506.S19 | PC 8000 | MEM 0 | 0,0,20,00,20,02 | MEM 2000 | 2,3,5 | RUN
N1			RMB 2				; VALOR ESPERADO EN "S" ($0000): $0A 
NN			RMB	2

			ORG $8000
			CLRA				; LIMPIO A
			CLR		S			; LIMPIO S
			LDX		N1			; CARGO LA POSICION DE MEMORIA N1 EN REGISTRO X
			
LOOP		ADDA	0,X			; SUMO EL CONTENIDO DE LA POSICION GUARDADA EN X AL ACUMULADOR A
			STAA	S+1			; ALMACENO EL CONTENIDO DEL ACUMULADOR A EN LA POSICION DE MEMORIA S (PARTE BAJA)
			BCS		CARRY
SIGO		CPX		NN			; ES X == NN (COMPARO POSICIONES DE MEMORIA)
			BEQ		FIN		; SI SON IGUALES -> FIN
			INX		1,X			; INCREMENTO EL REGISTRO X CON UN OFFSET DE 1
			BNE		LOOP		; SIGO
			
CARRY       INC		S			; SI HUBO CARRY INCREMENTO S (PARTE ALTA)
			BRA		SIGO
			
FIN			BRA		FIN			

* COP - 8000 4F - CLRA
* COP - 8001 7F - CLR
*  OP - 8002 00 - S
* COP - 8004 DE - LDX
* COP - 8005 AB - ADDA (SIGO)
*  OP - 8006 00 - 0,X
* COP - 8007 97 - STAA
*  OP - 8008 00 - S
* COP - 8009 9C - CPX
*  OP - 800A 03 - NN
* COP - 800B 27 - BEQ
*  OP - 800C 03 - FIN (Desde linea 30(inc) cuento +3 hasta la linea 33) 0000 0101 (3) -> CB -> 1111 1011 (FB)
* COP - 800D 08 - INX
* COP - 800E 26 - BNE
*  OP - 800F F5 - SIGO (Desde linea 32(inc) se cuentan -11 hasta la linea 22) 0000 1011 (11) -> CB -> 1111 0101 (F5)
* COP - 8010 20 - BRA
*  OP - 8011 FE - FIN