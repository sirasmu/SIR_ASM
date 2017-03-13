;loop of 0x2710 iterations
ldi		xh, 0x27
ldi		xl, 0x10
loop:		st -x, r16
		brne	loop
