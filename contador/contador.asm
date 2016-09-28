; contador

.include "/home/roger/arduino-asm/m328Pdef.inc"

.equ ascendente = 0x00
.equ descendente = 0x0f

.def salida = r16

init:
	ser salida			; establecer bits de registro r16 a 1's
	out DDRB,salida		; establecer pines digitales b como salidas
	out DDRD,salida 	; establecer pines digitales d como salidas

ldi r17,ascendente
ldi r18,descendente

incrementar:
	out PortB,r17	; establecer los pines a 0v
	inc r17

decrementar:
	out PortD,r18	; establecer los pines a 5v
	dec r18
	breq init

ldi r19,0xff
ldi r20,0xff
ldi r21,0xff

delay:
	dec r19
	brne delay
	dec r20
	brne delay
	dec r21
	brne delay
	rjmp incrementar
