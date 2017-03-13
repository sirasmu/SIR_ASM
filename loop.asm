;loop of 0x2710 iterations
			ldi		XH, 0x27
			ldi		XL, 0x10
	loop:	st -x, r16
			brne	loop
