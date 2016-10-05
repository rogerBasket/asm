; calculadora

.include "/home/roger/arduino-asm/m328Pdef.inc"

.def oper1 = r16
.def oper2 = r17
.def resul = r18
.def selec = r19
.def count = r20
.def aux = r21

; confuguracion de entradas

ldi oper1,0x00
out DDRD,oper1

ldi selec,0x00
out DDRC,selec

; configuracion de salidas

ldi resul,0xff
out DDRB,resul

; valor en entradas

ldi oper1,0xff
out PortD,oper1

ldi selec,0x07
out PortC,selec

init:
	in oper1,PinD
	andi oper1,0x0f

	in oper2,PinD
	andi oper2,0xf0
	ldi count,0x04
	rcall corrimiento

	in selec,PinC
	cpi selec,0b00000000
	breq calcu1
	cpi selec,0b00000001
	breq calcu2
	cpi selec,0b00000010
	breq calcu3
	cpi selec,0b00000011
	breq calcu4
	cpi selec,0b00000100
	breq calcu5
	cpi selec,0b00000101
	breq calcu6
	cpi selec,0b00000110
	breq calcu7
	cpi selec,0b00000111
	breq calcu8

	rjmp init

corrimiento:
	lsr oper2
	dec count
	cpi count,0
	brne corrimiento
	reti

calcu1:
	ldi aux,2
	mul oper1,aux
	mov resul,r0
	out PortB,resul
	rjmp init

calcu2:
	ldi aux,-4
	mul oper1,aux
	mov resul,r0
	out PortB,resul
	rjmp init

calcu3:
	mov oper2,oper1
	andi oper1,0x03
	andi oper2,0x0c
	lsr oper2
	lsr oper2
	add oper1,oper2
	out PortB,oper1
	rjmp init

calcu4:
	add oper1,oper2
	out PortB,oper1
	rjmp init

calcu5:
	mov oper1,oper2
	andi oper1,0x03
	andi oper2,0x0c
	lsr oper2
	lsr oper2
	sub oper2,oper1
	out PortB,oper2
	rjmp init

calcu6:
	neg oper1
	out PortB,oper1
	rjmp init

calcu7:
	mov oper2,oper1
	andi oper1,0x03
	andi oper2,0x0c
	lsr oper2
	lsr oper2
	mul oper1,oper2
	mov resul,r0
	out PortB,resul
	rjmp init

calcu8:
	and oper2,oper1
	com oper1
	or oper2,oper1
	out PortB,oper2
	rjmp init