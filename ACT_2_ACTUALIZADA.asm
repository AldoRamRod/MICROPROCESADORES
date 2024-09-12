;RAMIREZ RODRIGUEZ ALDO
;PROGRAMA PARA CALCULAR LA RA�Z CUADRADA DE UN N�MERO BCD
;EN EL REGISTRO B Y ALMACENAR EL RESULTADO EN C

;CODE SEGEMENT
		.ORG 0000H 	;MARCAMOS EL ORIGEN DEL PROGRAMA
	
;DEFINE STACK
		LD B, 25	;ASIGNAMOS UN VALOR EN B
		LD C,0		;INICIAMOS C EN 0 PUESTO QU AH� SE CARGAR� LA RA�Z CUADRADA
		LD A,B		;CARGAMOS EL VALOR BCD EN EL ACUMULADOR A
		CP 0		;HACEMOS COMPARACIONES DE EL VALOR YA OBTENIDO CON 0 
		JR Z, FIND
		CP 1		;HACEMOS COMPARACIONES DE EL VALOR YA OBTENIDO CON 1
		JR Z, FIND

		LD H,1		;INICIAMOS EL REGISTRO H EN 1 PARA ALMACENAR EL CUADRADO ACTUAL
		LD L,1		;LO USAMOS PARA ITERAR EL ALGORITMO
	
SQRT:		LD A,B		;CARGAMOS EL VALOR BCD EN EL ACUMULADOR A
		CP H		;COMPARAMOS A CON H
		JR C, MAYOR	;SI A ES MENOR QUE H SALTA A LA ETIQUETA MAYOR
		INC L		;y SE INCREMENTA EL VALOR DE L EN 1
		LD D,0		;INICIALIZAMOS LOS REGISTROS D Y E EN 0
		LD E,0
		
MULT:		LD A,E		;CARGAMOS EL VALOR DE E EN EL ACUMULADOR A
		ADD A,L		;SUMAMOS EL VALOR DE L A A
		LD E,A		;GUARDA EL RESULTADO DE LA SUMA EN EL REGISTRO E
		INC D		;INCREMENTANDO D EN 1
		LD A,L		;CARGAMOS EL VALOR DE L EN EL ACUMULADOR A
		CP D		;Y LO COMPARAMOS CON D
		JR NZ, MULT	;SI A NO ES IGUAL A D ENTONCES REGRESA AL BUCLE MULT
		LD H,E		;GUARDA EL VALOR E EN REGISTRO H
		JR SQRT		;Y SALTA DE VUELTA AL BUCLE SQRT

FIND:		LD C,A		;EN CASO DE ENCONTRAR LA RA�Z, SE GUARDA EL VALOR EN EL REGISTRO C
		JR CONV_BCD	;Y SE PASA A LA CONVERSI�N A BCD

MAYOR:		DEC L		;EN CASO DE ENCONTRAR UN CUIADRADO MAYOR QUE EL N�MERO ORIGINAL, ENTONCES DECREMENTA L
		LD C,L		;GUARDA EL VALOR DE LA RA�Z EN C
		JR CONV_BCD	;PASA A LA CONVERSI�N EN BCD

CONV_BCD:	LD A,B		;CARGA EL N�MERO ORIGINAL EN EL ACUMULADOR A
		LD E,0		;INICIALIZA E A 0
		
LOOP:		CP 10		;COMPARA A CON 10
		JR C, FINISH	;SI A ES MENOR QUE 10 ENTONCES SALTA A FINISH
		SUB 10		;RESTA 10 DE A
		INC E		; E INCREMENTA E
		JR LOOP		;SALTANDO DE VUELTA AL BUCLE
		
FINISH:		SLA E		;DESPLAZAMOS EL VALOR A LA IZQUIERDA POR 4 BITS
		SLA E
		SLA E
		SLA E
		OR E		;COMBINANDO EL VALOR EN E CON EL DE A
		LD B,A		;Y GUARDANDO EL VALOR RESULTANTE EN B
		HALT		;DETENI�NDOSE EL PROGRAMA

		.END



