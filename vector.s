
@----------------------------------------------------------
@ Autor: Luis Diego Fernandez, 16344 
@ Autor: María Mercedes Retolaza, 16339 
@ Seccion: 1011
@ Descripcion: Pre laboratorio 13, se manejan los calculos que involucran vectores 
@----------------------------------------------------------


/*** Using LEN and STRIDE to sum vectors ***/
	.global	main
	.func main
main:
/*	SUB SP, SP, #24	@ room for printf */
	LDR R8,=value1	@ Get addr of values
	LDR R9,=value2
	LDR R6,=value3
	MOV R10,#3
ciclo:

/* Los cambios que se realizaron fueron que se cambia el movimiento de los registros 
es decir ahora se mueven de 1 en 1 en vez de 2 en 2*/ 

	VLDR S16, [R8]		@ load values into
	VLDR S17, [R8,#4]		@ registers
	VLDR S19, [R8,#8]
	VLDR S20, [R8,#12]
	VLDR S24, [R9]
	VLDR S25, [R9,#4]
	VLDR S26, [R9,#8]
	VLDR S27, [R9,#12]

lenstride:
/* Set LEN(16-18)=4 0b011 and STRIDE(20-21)=2 0b11 */
	VMRS R3, FPSCR		@ get current FPSCR
	MOV R4,  #0b00011	@ bit pattern cambio de len 
	MOV R4, R4, LSL #16	@ move across to b21
	ORR R3, R3, R4		@ keep all 1's
	VMSR FPSCR, R3		@ transfer to FPSCR 
	/* Raiz cuadrada de los valores, se añade una instruccion directa, se evalua cada uno por separado
	y luego se junta */ 

	VSQRT.F32 S16,S16
	VSQRT.F32 S24, S24
	VADD.F32 S8, S16, S24	@ Vector addition in 


	VSTR S8,  [R6]
	VSTR S9, [R6,#4]
	VSTR S10, [R6,#8]
	VSTR S11, [R6,#12]

	ADD R6,#16
	ADD R8,#16
	ADD R9,#16
	SUBS R10,#1
	BNE  ciclo

convert_and_print:
/* Do conversion for printing, making sure not */
/* to corrupt Sx registers by over writing */
	MOV R10,#12
	LDR R6,add_value3
imprimir:
	VLDR S8,[R6]
	VCVT.F64.F32 D0, S8
	LDR R0,=formatoF		@ set up for printf
	VMOV R2, R3, D0
	BL printf
	ADD R6,#4
	SUBS R10,#1
	BNE imprimir 
_exit:
	MOV R0, #0
	MOV R7, #1
	SWI 0

add_value3: .word value3

	.data
value1:	.float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0
value2:	.float 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.101, 0.11, 0.12
value3:	.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

string:
.asciz " S8 is %f\n S10 is %f\n S12 is %f\n S14 is %f\n"

formatoF:
.asciz  "Valor %f\n"

