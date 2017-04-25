;
; Fibonacci.asm
;
; Created: 24-Apr-17 2:53:41 PM
; Author : SIR, AIC
;

start: 
// 2)	Find RAM addresses space at Atmel Studio, where you can store Fibonacci numbers.
.def X_HIGH=R27
.def X_LOW=R26
.def FIB_POSITION=R21
.def RESULT=R21
.equ MEMSTARTHIGH = 0x55
.equ MEMSTARTLOW = 0xAA

; Initialize array pointer to the start of the array where we will store the FIB-numbers
LDI X_HIGH, MEMSTARTHIGH
LDI X_LOW, MEMSTARTLOW

//3)	Make RAM test on those RAM locations before running your Fibonacci program 

ADD X_HIGH,X_LOW
CPI X_HIGH,0xFF
BREQ CLEAR
RJMP NEXT
CLEAR:
		LDI X_HIGH,0x00
		LDI X_LOW,0x00


/*
4)To train your skills concerning the stack, POP, PUSH, CALL and RETurn, 
you should now use the VIA Calling Convention to implement a recursive 
version of fib-function (Fibonacci sequence).*/

LDI FIB_POSITION, 3 //where we start from

NEXT:	CPI FIB_POSITION, 5 //we're looking for Fibonacci number at position 5
 		BREQ DONE

		; Setup call, pushing the argument:
		PUSH FIB_POSITION
		; CALL the subroutine:
		CALL FIBONACCI
		; Retrieve the result (return value):
		POP RESULT

		; Store results and continue
		ST X+, RESULT
		INC FIB_POSITION
		JMP NEXT

FIBONACCI: 	 
	PUSH RESULT        ;Push all the registers we use for our calculation onto the stack
    PUSH R22
    PUSH R16   
    PUSH R18
    PUSH X_LOW
    PUSH X_HIGH
           
    IN X_LOW, SPL     ;Lower stack point register
    IN X_HIGH, SPH     ;High stack point register
    ADIW X_LOW, 10    ;Adds an immediate value (0-63) to a register pair and places the result in the register pair.
    LD RESULT, X       ;Load value from RAM (X) (Our N number -> our fibonacci number) into Register 21
 
    CPI RESULT,0       ;IF condition to check if our finonacci number is 0,
    BREQ IFZERO     ;Then go to IFZERO
       
    CPI RESULT,1       ;IF condition to check if our finonacci number is 1, then go to IFZERO
    BREQ IFONE      ;Then go to IFONE
 
    DEC RESULT         ;Decrement the value in register 21 (N-1)
    PUSH RESULT        ;Push the value of register 21 to the stack
    CALL FIBONACCI  ;Call the method itself for the use of recursive
    POP R22         ;Pop register from the stack, so here we store the value of fibonacci(N-1)
 
    DEC RESULT         ;Decrement the value in register 21 again, so now it is (N-2)
    PUSH RESULT        ;Push the value of register 21 to the stack
    CALL FIBONACCI  ;HERE I CAN'T SEE HOW THE RECURSIVE ACTUALLY WORKS, BUT IT WORKS FINE
    POP R16         ;Pop register from the stack, so here we store the value of fibonacci(N-2)
 
    ADD R22,R16     ;Adding the fibonacci(N-1) + fibonacci(N-2) together (our formula) into register 22
    ST X,R22        ;Store the value from register 22 into our RAM stack address
           
ENDFIBONACCI:
    POP X_HIGH         ;Popping all the register we use for the calculation from the stack
    POP X_LOW
    POP R18
    POP R16
    POP R22
    POP RESULT
    RET             ;Returning to the start frequency again, in this case NEXT
 
IFONE:
    LDI R18, 1      ;Store value 1 into register 18, to return 1 in case our fibonacci number is 1
    ST X,R18        ;Store the value from register 18 into our RAM stack address
    RJMP ENDFIBONACCI
       
IFZERO:
    LDI R18, 1      ;Store value 1 into register 18, to return 1 in case our fibonacci number is 0
    ST X,R18        ;Store the value from register 18 into our RAM stack address
    RJMP ENDFIBONACCI
DONE: RJMP DONE
