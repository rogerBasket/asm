; display catoto comun

.include "/home/roger/arduino-asm/m328Pdef.inc"

.def salida = r16
.def entrada = r17

.org 0x0008
segments:
	.db 0b00111111, 0b00000110, 0b01011011, 0b01001111
	.db 0b01100110, 0b01101101, 0b01111100, 0b00000111
	.db 0b01111111, 0b01100111

ldi salida,0xff
ldi entrada,0x00

out DDRD,salida
;out DDRB,entrada
out DDRC,entrada

ldi entrada,0x0f
;out PortB,entrada
out PortC,entrada

init:
	ldi Zl,low(segments*2)
	ldi Zh,high(segments*2)
	;in entrada,PinB
	in entrada,PinC
	add Zl,entrada
	lpm r18,Z
	out PortD,r18
	rjmp init

loop:
	rjmp loop