;Programa que genera 20 números aleatorios y ordena de forma ascendente o descendente dependiendo de la elección del usuario
;AUTHOR: Ramírez Rodríguez Aldo

;MAIN PROGRAM

    		.ORG 0000H		;SE DA ORIGEN
    		LD SP,27FFH		;SE INICIALIZA EL STACK POINTER

INICIO:
    		LD A,89H		;SE CARGA EL VALOR EN A
    		OUT (CW),A		;SE ENVÍA EL VALOR DE A AL PUERTO DE CONTROL CW
    		LD HL,texto_entrada	;CARGA EL TEXTO DE ENTRADA EN EL REGISTRO HL
    		CALL mostrar_texto	;LLAMA LA SUBRUTINA MOSTRAR TETXO
    		LD HL,27FFH		
    		LD B,20
    		CALL random		;LLAMA A LA SUBRUTINA QUE GENERA LOS 20 NÚMEROS RANDOM
    		LD HL,27FFH
    		LD B,20
    		CALL mostrar_num
    		LD HL,orden_texto		;CARGA EL TEXTO QUE PREGUNTA EL ORDEN QUE SE DESEA OBTENER
    		CALL mostrar_texto
    		IN A,(KEYB)		;CARGA EL CARACTER DEL TECLADO Y LO GUARDA EN EL ACUMULADOR A
    		CP 'A'			;LO COMPARA CON A
    		JP Z,orden_ascen	;SI ES A, SALTA A LA SUBRUTINA DE ORDEN ASCENDENTE
    		CP 'D'			;SI NO ES A, COMPARA CON D
    		JP Z,orden_descen	;SI ES D, SALTA A LA SUBRUTINA DE ORDEN DESCENDENTE
    		CALL mostrar_num_ord	;LLAMA A LA SUBRUTINA CON NÚMEROS ORDENADOS
    		CALL pregunta		;LLAMA A LA SUBRUTINA DE LA PREGUNTA SOBRE SI DESEA CONTINUAR EN EL PROGRAMA
    		HALT

;SUBROUTINES
mostrar_texto:
    		LD A,(HL)
    		CP '&'
   		JP Z,fin_texto
    		OUT (LCD),A
    		INC HL
    		JP mostrar_texto
fin_texto:
    		RET

random:
    		LD A,R
    		LD (HL),A
    		INC HL
    		DJNZ random
    		RET

mostrar_num:
    		LD A,(HL)
    		CALL conv_decimal
    		INC HL
    		DJNZ mostrar_num
    		RET

conv_decimal:
    		LD B,10
    		LD D,0

num_decenas:
    		CP B
    		JP mostrar_unidades
    		SUB B
    		INC D
    		JP num_decenas

mostrar_decenas:
    		LD A,D
    		ADD A,'0'
    		OUT (LCD),A

num_unidades:
    		CP B
    		JP fin_conv
    		SUB B
    		INC D
    		JP num_unidades

mostrar_unidades:
    		LD A,(HL)
    		AND 0FH
    		LD B,10
    		LD D,0
fin_conv:
    		LD A,D
    		ADD A,'0'
   		OUT (LCD),A
    		RET

orden_ascen:
    		LD HL,27FFH
    		LD B,20

asc_loop:
    		LD D,B
    		DEC D
    		LD HL,27FFH

asc_int:
    		LD A,(HL)
    		LD C,(HL+1)   ;Carga el siguiente valor
    		CP C
    		JR C,nsw_asc
    		LD (HL),C     ;Intercambia los valores si no están en orden
    		LD (HL+1),A

nsw_asc:
    		INC HL
    		INC HL        ;Avanza al siguiente par de números
    		DJNZ asc_int
   		    DJNZ asc_loop
    		RET

orden_descen:
    		LD HL,27FFH
    		LD B,20

desc_loop:
    		LD D,B
    		DEC D
    		LD HL,27FFH

desc_int:
    		LD A,(HL)
    		LD C,(HL+1)   ;Carga el siguiente valor
    		CP C
    		JR NC,nsw_desc
    		LD (HL),C     ;Intercambia los valores si no están en orden
    		LD (HL+1),A

nsw_descendente:
    		INC HL
    		INC HL        ;Avanza al siguiente par de números
    		DJNZ desc_int
    		DJNZ desc_loop
    		RET

mostrar_num_ord:
    		LD HL,27FFH
    		LD B,20

loop_mostrar_ord:
    		LD A,(HL)
    		CALL conv_decimal
    		INC HL
    		DJNZ loop_mostrar_ord
    		RET

pregunta:
    		LD HL,pregunta_texto
    		CALL mostrar_texto
    		IN A,(KEYB)
    		CP 'R'
    		JP Z,inicio
    		CP 'S'
    		JP Z,fin_programa

fin_programa:
    		LD HL,texto_final
   		    CALL mostrar_texto
    		HALT

;DATA SEGMENT

    		.ORG 2000H
LCD  		.equ 01h
KEYB	 	.equ 02h
CW     		.equ 03h
texto_entrada 	.db "INICIANDO PROGRAMA, CARGANDO NÚMEROS ALEATORIOS&"
orden_texto 	.db "¿ORDENAR ASCENDENTE O DESCENDENTE?&"
pregunta_texto 	.db "¿REPETIR (R) O SALIR (S)?&"
texto_final	.db "HA SALIDO DEL PROGRAMA.&"

;END OF PROGRAM
    		.end
