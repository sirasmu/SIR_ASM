;My own algorithm for dividing in assembly... I'll name it SIR_ASM_DIV
	.def    a = r16           	;To hold dividend
	.def    b = r17           	;To hold divisor
	.def	i = r18			;Count for amounts of time you went though the loop.. This is the result
	.def	c = r19			;Count for whether you reached the value of a
	.def	r = r20			;Remainder
	.def	d = r21			;Used as c-1 to see whether c is greater than a
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
	brge correction; If c > a then the i and c counts needs to be corrected
	remainder:	
		mov r, a
		sub r, c
		rjmp start
	correction: 
		sub c, b
		dec i
		rjmp remainder
