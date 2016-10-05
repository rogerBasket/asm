; rotacion de portD a portB

.include "/home/roger/arduino-asm/m328Pdef.inc"

.def aux = r16
.def counter = r17
.def registro = r18
.def temp = r19

.org 0x0000
	rjmp reset
.org 0x0020
	rjmp timer

reset:
   ldi temp,0b00000101
   out TCCR0B,temp      	; set the Clock Selector Bits CS00, CS01, CS02 to 101
                         	; this puts Timer Counter0, TCNT0 in to FCPU/1024 mode
                         	; so it ticks at the CPU freq/1024
   ldi temp,0b00000001
   sts TIMSK0,temp      	; set the Timer Overflow Interrupt Enable (TOIE0) bit 
                         	; of the Timer Interrupt Mask Register (TIMSK0)

   sei                   	; enable global interrupts -- equivalent to "sbi SREG, I"

   clr temp
   out TCNT0,temp       ; initialize the Timer/Counter to 0

; configuracion de aux

ldi aux,0x00
out DDRD,aux

; configuracion de aux

ldi aux,0xff
out DDRB,aux

ldi aux,0x30
out DDRC,aux

; valor de auxs

ldi aux,0xff
out PortD,aux

init:
	in temp,PinD
	out PortB,temp
	mov registro,temp
	ldi counter,0x00

ciclo:
	rcall segundos
	rcall datos

	cp aux,temp
	brne init

	rjmp ciclo

rotar:
	clr counter
	rol registro
	brcs carry

	rjmp salida

carry:
	inc registro
	rjmp salida

salida:
	mov aux,registro

	out PortB,registro

	lsr aux
	lsr aux
	out PortC,aux

	reti

datos:
	in aux,PinD
	reti

segundos:
	cpi counter,122
	brne PC+2
	rcall rotar
	reti

timer:
	inc counter
	reti