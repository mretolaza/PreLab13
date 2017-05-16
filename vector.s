
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
	VLDR S16, [R8]		@ load values into
	VLDR S18, [R8,#4]		@ registers
	VLDR S20, [R8,#8]
	VLDR S22, [R8,#12]
	VLDR S24, [R9]
	VLDR S26, [R9,#4]
	VLDR S28, [R9,#8]
	VLDR S30, [R9,#12]
lenstride:
/* Set LEN(16-18)=4 0b011 and STRIDE(20-21)=2 0b11 */
	VMRS R3, FPSCR		@ get current FPSCR
	MOV R4,  #0b11011	@ bit pattern
	MOV R4, R4, LSL #16	@ move across to b21
	ORR R3, R3, R4		@ keep all 1's
	VMSR FPSCR, R3		@ transfer to FPSCR 
	VADD.F32 S8, S16, S24	@ Vector addition in parallel

	VSTR S8, [R6]
	VSTR S10, [R6,#4]
	VSTR S12, [R6,#8]
	VSTR S14, [R6,#12]

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

