; rotacion de portD a portB

.include "/home/roger/arduino-asm/m328Pdef.inc"

.def entrada = r16
.def salida = r17
.def temp = r18
.def counter = r19
.def aux = r20
.def registro = r21

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

; configuracion de entrada

ldi entrada,0x00
out DDRD,entrada

; configuracion de salida

ldi salida,0xff
out DDRB,salida

ldi salida,0x30
out DDRC,salida

; valor de entradas

ldi entrada,0xff
out PortD,entrada

init:
	in temp,PinD
	out PortB,temp
	mov registro,temp
	ldi counter,0x00
	ldi entrada,0x00

ciclo:
	rcall segundos
	
	cpi entrada,8
	breq init

	rcall datos

	cp aux,temp
	brne init

	rjmp ciclo

rotar:
	rol registro
	mov salida,registro
	out PortB,registro

	lsr salida
	lsr salida
	out PortC,salida

	clr counter
	reti

datos:
	in aux,PinD
	reti

segundos:
	cpi counter,122
	brne PC+3
	rcall rotar
	inc entrada
	reti

timer:
	inc counter
	reti