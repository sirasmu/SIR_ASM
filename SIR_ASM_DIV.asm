;My own algorithm for dividing in assembly... I'll name it SIR_ASM_DIV
	.def    a = r16           	;To hold dividend
	.def    b = r17           	;To hold divisor
	.def	c = r19			;Count for whether you reached the value of a
	.def	d = r21			;Copies c and decrements. Used as c-1 to see whether c is greater than a
	.def	i = r18			;Result. Counts amount of times the b value can be added to itself before reaching a
	.def	r = r20			;Remainder. Copies a and substracts c from it.
	ldi a, 6
	ldi b, 3
	ldi i, 0
	ldi c, 0
	loop: 
		add c, b  
		inc i
		cp a, c;
		brge loop; Should jump to the start of the loop if c < a
	mov d, c
	dec d
	cp d, a; 
	brge correction; If c > a then the i and c counts will need to be corrected
	remainder:	
		mov r, a
		sub r, c
		rjmp start
	correction: 
		sub c, b
		dec i
		rjmp remainder
