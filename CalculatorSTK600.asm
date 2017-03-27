;
; CalculatorSTK600.asm
;
; Created: 20-03-2017 13:23:06
; Author : SIR
;


start:
.include "m2560def.inc"
	.def	a = r16				;Number 1 to add together
	.def	b = r17				;Number 2 to add together
	.def	result = r18			;Result of the calculation with a and b
	.def	switch = r19			;Input
	.def	light = r20			;Output
	.def	temp = r21			;Used for saving temporary information

	ldi switch, 0x00			;Load low value for Input port
	out ddrA, switch			;Configure PortA as an Input port
	ldi light, 0xff				;Load high value for Output port
	out ddrB, light				;Configure PortB as an Output port
	
	next_a:					;The "next" is used 
		call long_delay			;Not necesarry, but if the code is changed to be able to loop back to the start it is useful to prevent the registration of a button press
		ldi a, 0			;Value 'a' and 'b' needs to be cleared so no mistake in the calculation happens in the case of not providing a new input
		ldi b, 0
		ldi light, 0b11111111		;Just so that no light is on when the program starts, might be removed
		loop_a:				;Should keep looping until you have given the input for the desired 'a' value
			in switch, pinA		;Get the input from the switch
			call delay 		;Prevent jitter

			cpi switch, 0b01111111	;Save current 'a' value if "Enter" switch is pressed. The value of "Enter" is 0b01111111
			breq next_b

			mov temp, switch	;Save 'a' value, maybe put this into a function call
			com temp
			add a, temp
			mov temp, a
			com temp

			mov light, temp		;Update the light output
			out portB, light
			call long_delay 	;To prevent immediate addtion when holding the swithch for prolonged time
			rjmp loop_a
	
	next_b:
		call long_delay			;This is to prevent that the previous selection will be taken as a switch input
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
		call long_delay			;This is to prevent that the previous selection will be taken as a switch input
		ldi light, 0b11111111
		out portB, light

		loop_operator:
			in switch, pinA
			call long_delay

			cpi switch, 0b11111110 ;If this value is read from the swithc input do an addition where "a+b=result"
			breq addition

			cpi switch, 0b11111101 ;If this value is read from the swithc input do a subtraction where "a-b=result"
			breq subtraction

			cpi switch, 0b11111011 ;If this value is read from the swithc input do a multiplication where "a*b=result"
			breq multiplication

			cpi switch, 0b11110111 ;If this value is read from the swithc input do a division where "a/b=result"
			breq division

			rjmp loop_operator
	next_calculate:
		loop_result:			;Keep displaying the result
			mov light, result
			com light
			out portB, light
			rjmp loop_result

/************FUNCTIONS TO CALL******************/
	delay:  ldi r24,255
		d1:	ldi r25, 255
		d2:	nop
			nop
			dec r25
			brne d2
			dec r24
			brne d1
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
