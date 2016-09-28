;hello.asm
;  turns on an LED which is connected to PB5 (digital out 13)

.include "/home/roger/arduino-asm/m328Pdef.inc"

	ldi r16,0b00000100
	out DDRB,r16
	out PortB,r16
Start:
	rjmp Start