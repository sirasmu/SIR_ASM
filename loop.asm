;loop of 0x2710 iterations
ldi		xh, 0x27
ldi		xl, 0x10
loop:		st -x, r16; I want to see if there is a better way of doing this, since r16 is of no relevance
		brne	loop
