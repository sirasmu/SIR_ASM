;
; FibonacciSequence.asm
;
; Created: 24-04-2017 14:22:37
; Author : SIR, AIC
;


; Replace with your application code
START:
/*2) Find RAM addresses space at Atmel Studio, where you can store Fibonacci numbers.*/
	.def X_HIGH = r27
	.def X_LOW = r26

	.equ FIBNUM = 12
	.equ MEMSTARTHIGH = 0x55
	.equ MEMSTARTLOW = 0xAA

	; Initialize array pointer to the start of the array where we will store the FIB-numbers
	LDI X_HIGH, MEMSTARTHIGH
	LDI X_LOW, MEMSTARTLOW

/* 3) Make RAM test on those RAM locations before running your Fibonacci program
	Add 0x55 with 0xAA at the selected RAM addresses
	
*/
	ADD X_HIGH, X_LOW

	CPI X_HIGH, 0xFF
	BREQ CLEAR

	RJMP NEXT0

	CLEAR :
		LDI X_HIGH, 0x00
		LDI X_LOW, 0X00

	NEXT0: 
/* 4) To train your skills concerning the stack, POP, PUSH, CALL and RETurn, you should now use the VIA Calling Convention to implement a recursive version of fib-function (Fibonacci sequence). */		
	.def FIBTH = R20
	.def RESULT = R21
	
	LDI FIBTH, 3

	LOOP: 
		CPI FIBTH, 12 ; The program will end when the 12th fibonacci number is found
		BREQ DONE

		PUSH FIBTH ; Push the FIBSTART value onto the stack
		CALL FIB 
		POP RESULT ; Increment the Stack Pointer what the stack points at will be returned and saved in RESULT

		;Store results and continue
		ST X+, RESULT ;Stores RESULT at X_HIGH and X_LOW and increment pointer
		INC FIBTH ; Increment the Fibonacc number to look at
		JMP LOOP

	FIB:
		
	DONE:
		RJMP DONE
