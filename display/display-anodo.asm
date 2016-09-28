; display anodo comun

.include "/home/roger/arduino-asm/m328Pdef.inc"

.def salida = r16
.def entrada = r17

.org 0x0008
segments:
	.db 0b11000000, 0b11111001, 0b10100100, 0b10110000
	.db 0b10011001, 0b10010010, 0b10000011, 0b11111000
	.db 0b10000000, 0b10011000

ldi salida,0xff
ldi entrada,0x00

out DDRD,salida
out DDRB,entrada

ldi entrada,0x0f
out PortB,entrada

;ldi r19,0x05

init:
	ldi Zl,low(segments*2)
	ldi Zh,high(segments*2)
	in entrada,PinB
	add Zl,entrada
	lpm r18,Z
	out PortD,r18
	rjmp init

loop:
	rjmp loop