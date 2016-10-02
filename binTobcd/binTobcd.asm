; binario de 6 bits a bcd 2 digitos

.include "/home/roger/arduino-asm/m328Pdef.inc"

.def binario = r16
.def unidad = r17
.def decena = r18
.def counter = r19
.def temp = r20

.org 0x0000
	rjmp reset
.org 0x0020
	rjmp timer

segments:
	.db 0b00111111, 0b00000110, 0b01011011, 0b01001111
	.db 0b01100110, 0b01101101, 0b01111100, 0b00000111
	.db 0b01111111, 0b01100111

reset:
   ldi binario,0b00000101
   out TCCR0B,binario      	; set the Clock Selector Bits CS00, CS01, CS02 to 101
                         	; this puts Timer Counter0, TCNT0 in to FCPU/1024 mode
                         	; so it ticks at the CPU freq/1024
   ldi binario,0b00000001
   sts TIMSK0,binario      	; set the Timer Overflow Interrupt Enable (TOIE0) bit 
                         	; of the Timer Interrupt Mask Register (TIMSK0)

   sei                   	; enable global interrupts -- equivalent to "sbi SREG, I"

   clr binario
   out TCNT0,binario       ; initialize the Timer/Counter to 0

; salidas
ldi binario,0xff
out DDRD,binario
out DDRB,binario

; entrada
ldi binario,0x00
out DDRC,binario

ldi binario,0x3f
out PortC,binario


init:
	in binario,PinC
	ldi temp,0x00
	ldi counter,0x00

ciclo:
	ldi Zl,low(segments<<1)
	ldi Zh,high(segments<<1)

	; escribir unidades en puerto D
	mov unidad,binario
	rcall decenas
	add Zl,unidad
	lpm unidad,Z
	out PortD,unidad

	ldi Zl,low(segments<<1)
	ldi Zh,high(segments<<1)

	; escribir decenas en puerto B
	add Zl,decena
	lpm decena,Z
	out PortB,decena
	andi decena,0x40
	lsl decena
	out PortD,decena

	cpi counter,140
	brne ciclo

	rcall count
	cpi temp,10
	breq PC+2
	rjmp ciclo
	rjmp init

count:
	ldi counter,0x00
	;cpi temp,10
	;breq PC+3
	inc binario
	inc temp
	reti

decenas:
	ldi decena,0x00
unidades:
	subi unidad,10
	brcs backup
	inc decena
	rjmp unidades

backup:
	subi unidad,-10
	reti

timer:
	inc counter
	;cpi counter,122 ; contar 2 segundos
	;brne PC+2
	;clr counter
	reti