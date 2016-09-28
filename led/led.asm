; Turns on an led connected to PB0 (digital 0)
; when you push a button connected to PD0

.include "/home/roger/arduino-asm/m328Pdef.inc"

.def temp = r16

ser temp
out DDRB,temp

clr temp
out DDRD,temp

clr temp
out PortB,temp

ser temp
out PortD,temp

Main:
	in temp,PinD
	out PortB,temp
	rjmp Main