;
; Fibonacci.asm
;
; Created: 24-Apr-17 2:53:41 PM
; Author : SIR, AIC
;

start: 
.def X_HIGH = R27		; The high value of the X Register
.def X_LOW = R26		; The low value of the X Register
.def FIB_POSITION = R20
.def RESULT = R21		;This
.equ MEMSTARTHIGH = 0x55
.equ MEMSTARTLOW = 0xAA

;-------------------------
.def LIGHT = R23			;Output
LDI LIGHT, 0xFF				;Load high value for Output port
OUT DDRB, LIGHT				;Configure PortB as an Output port
;-------------------------

; Initialize array pointer to the start of the array where we will store the FIB-numbers
LDI X_HIGH, MEMSTARTHIGH
LDI X_LOW, MEMSTARTLOW

/*
3) Make RAM test on those RAM locations before running your Fibonacci program 
*/

ADD X_HIGH, X_LOW
CPI X_HIGH, 0xFF
BREQ CLEAR
RJMP NEXT
CLEAR:
		LDI X_HIGH, 0x00
		LDI X_LOW, 0x00


/*
4) To train your skills concerning the stack, POP, PUSH, CALL and RETurn, 
you should now use the VIA Calling Convention to implement a recursive 
version of fib-function (Fibonacci sequence).
*/

LDI FIB_POSITION, 1 ;Where we start from

NEXT:	
	CPI FIB_POSITION, 3 ;We're looking for Fibonacci number at position 5
 	BREQ DISPLAY			;The program will end when the number being compared to is reached
	
	; Setup call, pushing the argument:
	PUSH FIB_POSITION	;Put the value onto the stack and decrement the stack pointer
	; CALL the subroutine:
	CALL FIBONACCI
	; Retrieve the result (return value):
	POP RESULT			;Increment the stack pointer what the stack points at will be returned and saved in RESULT

	; Store results and continue
	ST X+, RESULT		;Stores RESULT at X_HIGH and X_LOW and increment pointer
	INC FIB_POSITION	;Increment the fibonacci position to look at
	JMP NEXT

FIBONACCI: 	 
	PUSH RESULT			;Push all the registers we use for our calculation onto the stack
    PUSH R22			;N-1
    PUSH R16			;N-2
    PUSH R18			;Used for storing the value of the base case
    PUSH X_LOW			
    PUSH X_HIGH
           
    IN X_LOW, SPL		;Lower stack point register
    IN X_HIGH, SPH		;High stack point register
    ADIW X_LOW, 10		;Adds an immediate value (0-63) to a register pair and places the result in the register pair.
    LD RESULT, X		;Load value from RAM (X) (Our N number -> our fibonacci number) into Register 21
 
    CPI RESULT, 0       ;IF condition to check if our finonacci number is 0
    BREQ BASECASE		;Then go to the base case  
    CPI RESULT, 1       ;IF condition to check if our finonacci number is 1
    BREQ BASECASE		;Then go to the base case
 
    DEC RESULT			;Decrement the value in register 21 (N-1)
    PUSH RESULT			;Push the value of register 21 to the stack
    CALL FIBONACCI		;Call the method itself for the use of recursive
    POP R22				;Pop register from the stack, so here we store the value of fibonacci(N-1)
 
    DEC RESULT			;Decrement the value in register 21 again, so now it is (N-2)
    PUSH RESULT			;Push the value of register 21 to the stack
    CALL FIBONACCI		;Recursive call of the fibonacci subrutine
    POP R16				;Pop register from the stack, so here we store the value of fibonacci(N-2)
 
    ADD R22,R16			;Adding the fibonacci(N-1) + fibonacci(N-2) together (our formula) into register 22
    ST X, R22			;Store the value from register 22 into our RAM stack address
           
ENDFIBONACCI:
    POP X_HIGH			;Popping all the register we use for the calculation from the stack
    POP X_LOW
    POP R18
    POP R16
    POP R22
    POP RESULT
    RET					;Returning to the frequency again at the line after the call
 
BASECASE:
    LDI R18, 1			;Store value 1 into register 18, to return 1 in case our fibonacci number is 1
    ST X, R18			;Store the value from register 18 into our RAM stack address
    RJMP ENDFIBONACCI

DONE: 
	RJMP DONE

DISPLAY:					;Display the values found in the Fibonacci sequence
		LDI R26, 0x00			;Set the X pointer to the start
		REPEAT:		
			LD LIGHT, X+		;Increment the X pointer and load the X value into the LIGHT registry
			COM LIGHT		;Invert value for displaying it
			RJMP OUTPUT_LOOP	
			RJMP REPEAT	

	OUTPUT_LOOP: 
		OUT PORTB, LIGHT				;Light up the LEDs so the binary value of the fibonacci number can be read
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY	
		LDI R17, 0xFF
		OUT PORTB, R17					;Turn off LEDs
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		CALL LONG_DELAY						
		RJMP REPEAT				

	 DELAY:  LDI r24,255
		D1:	LDI r25, 255
		D2:	NOP
			NOP
			DEC r25
			BRNE d2
			DEC r24
			BRNE d1
			RET
	
LONG_DELAY:
		CALL delay
		CALL delay
		CALL delay
		CALL delay
		CALL delay
		CALL delay
		CALL delay
		CALL delay
		RET
       

