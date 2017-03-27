;
; CalculatorSTK600.asm
;
; Created: 20-03-2017 13:23:06
; Author : SIR
;


; Replace with your application code
start:
.include "m2560def.inc"
	.def	a = r16					;Number 1 to add together
	.def	b = r17					;Number 2 to add together
	.def	result = r18			;Result of the calculation with a and b
	.def	operator = r19			;Operator to use with a and b
	.def	switch = r20			;input
	.def	light = r21				;output
	.def	temp = r22				;ehhh

	ldi switch, 0x00					;Load low value for Input port
	out ddrA, switch					;Configure PortA as an Input port
	ldi light, 0xff					;Load high value for Output port
	out ddrB, light					;Configure PortB as an Output port
	
	next_a:
		call long_delay ;only needed if you decide to loop back after a calculation
		ldi a, 0
		ldi b, 0
		ldi light, 0b11111111
		loop_a:
			in switch, pinA
			call delay ;Prevent jitter

			cpi switch, 0b01111111 ;Save value if "Enter" switch is pressed. The value of "Enter" is 0b10000000
			breq next_b

			mov temp, switch
			com temp
			add a, temp
			mov temp, a
			com temp

			mov light, temp
			out portB, light
			call long_delay ;To prevent immediate addtion when holding the swithch for prolonged time
			rjmp loop_a
	
	next_b:
		call long_delay
		ldi light, 0b11111111
		loop_b:
			in switch, pinA
			call delay
	
			cpi switch, 0b01111111 ;Save value if "Enter" switch is pressed. The value of "Enter" is 0b01111111
			breq next_operator

			mov temp, switch
			com temp
			add b, temp
			mov temp, b
			com temp

			mov light, temp 
			out portB, light
			call long_delay
			rjmp loop_b
	
	next_operator: ;not in use atm
		call long_delay
		ldi light, 0b11111111
		out portB, light

		loop_operator:
			in switch, pinA
			call long_delay

			cpi switch, 0b11111110 ;Save value if "Enter" switch is pressed. The value of "Enter" is 0b10000000
			breq addition

			cpi switch, 0b11111101 ;Save value if "Enter" switch is pressed. The value of "Enter" is 0b10000000
			breq subtraction

			cpi switch, 0b11111011 ;Save value if "Enter" switch is pressed. The value of "Enter" is 0b10000000
			breq multiplication

			cpi switch, 0b11110111 ;Save value if "Enter" switch is pressed. The value of "Enter" is 0b10000000
			breq division

			rjmp loop_operator
	next_calculate:
		loop_result:
			mov light, result
			com light
			out portB, light
			rjmp loop_result

/************FUNCTIONS TO CALL******************/
	delay:
			ldi r23, 1
		d0:	ldi r24,255
		d1:	ldi	r25, 255
		d2:	
			nop
			nop
			dec r25
			brne d2
			dec r24
			brne d1
			dec r23
			brne d0
			ret
	
	long_delay:
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		ret

	addition:
		ldi light, 0b11111110
		out portB, light

		call long_delay
		call long_delay

		mov result, a
		add result, b
		rjmp next_calculate

	subtraction:
		ldi light, 0b11111101
		out portB, light

		call long_delay
		call long_delay

		mov result, a
		neg b // second complement for b		
		add result, b
		rjmp loop_result

	multiplication:
		ldi light, 0b11111011
		out portB, light

		call long_delay
		call long_delay

		mul a,b
		mov result, r0
		rjmp loop_result

	;My own algorithm for dividing in assembly... I'll name it SIR_ASM_DIV
	division:
	ldi light, 0b11110111
	out portB, light

	call long_delay
	call long_delay

	.def	c = r23			;Count for whether you reached the value of a
	.def	d = r24			;Copies c and decrements. Used as c-1 to see whether c is greater than a
	ldi result, 0
	ldi c, 0
	loop: 
		add c, b  
		inc result
		cp a, c;
		brge loop; Should jump to the start of the loop if c < a
	mov d, c
	dec d
	cp d, a; 
	brge correction; If c > a then the i and c counts will need to be corrected
	remainder:	
		//not needed
		rjmp loop_result
	correction: 
		sub c, b
		dec result
		rjmp remainder