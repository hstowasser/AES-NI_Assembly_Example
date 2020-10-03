SECTION .DATA

SECTION .TEXT
	GLOBAL Cipher
	GLOBAL InvCipher
	GLOBAL KeyExpansion

shuffle:
	vpshufd xmm0, xmm0, 0b11111111		;copy w' into every word
	xorpd xmm0, xmm3					; w' xor w0,w1,w2,w3
	vpslldq xmm3, xmm3, 4				;shift out w3
	xorpd xmm0, xmm3
	vpslldq xmm3, xmm3, 4				;shift out w2
	xorpd xmm0, xmm3
	vpslldq xmm3, xmm3, 4				;shift out w1
	xorpd xmm0, xmm3					; xmm0 now contains round key
	ret

KeyExpansion: ;KeyExpansion(uint8_t* RoundKey, const uint8_t* Key);
	movdqu xmm1, [rsi]					;load key

	movdqu [rdi],xmm1

	movdqu xmm3, xmm1
	aeskeygenassist xmm0, xmm1, 0x01    ;generate round 1 key
	call shuffle
	movdqu [rdi+16],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x02    ;generate round 2 key
	call shuffle
	movdqu [rdi+32],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x04    ;generate round 3 key
	call shuffle
	movdqu [rdi+48],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x08    ;generate round 4 key
	call shuffle
	movdqu [rdi+64],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x10    ;generate round 5 key
	call shuffle
	movdqu [rdi+80],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x20    ;generate round 6 key
	call shuffle
	movdqu [rdi+96],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x40    ;generate round 7 key
	call shuffle
	movdqu [rdi+112],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x80    ;generate round 8 key
	call shuffle
	movdqu [rdi+128],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x1B    ;generate round 9 key
	call shuffle
	movdqu [rdi+144],xmm0				;save result to key_table

	movdqu xmm3, xmm0
	aeskeygenassist xmm0, xmm0, 0x36    ;generate round 10 key
	call shuffle
	movdqu [rdi+160],xmm0				;save result to key_table
	ret

Cipher: ; Cipher(state_t* state, const uint8_t* RoundKey);
	movdqu xmm1, [rsi]					;load key
	movdqu xmm0, [rdi]					;load data

	xorpd xmm0, xmm1					;xor key
	aesenc xmm0, [rsi+16]				;round key 1
	aesenc xmm0, [rsi+32]				;round key 2
	aesenc xmm0, [rsi+48]				;round key 3
	aesenc xmm0, [rsi+64]				;round key 4
	aesenc xmm0, [rsi+80]				;round key 5
	aesenc xmm0, [rsi+96]				;round key 6
	aesenc xmm0, [rsi+112]				;round key 7
	aesenc xmm0, [rsi+128]				;round key 8
	aesenc xmm0, [rsi+144]				;round key 9
	aesenclast xmm0, [rsi+160]			;round key 10

	movdqu [rdi],xmm0					;overwrite state
	ret

InvCipher: ;InvCipher(state_t* state, const uint8_t* RoundKey)
	movdqu xmm0, [rdi]					;load data
	movdqu xmm1, [rsi+160]				;load last key

	xorpd xmm0, xmm1					;xor last key
	aesimc xmm1, [rsi+144]				;round key 9
	aesdec xmm0, xmm1
	aesimc xmm1, [rsi+128]				;round key 8
	aesdec xmm0, xmm1
	aesimc xmm1, [rsi+112]				;round key 7
	aesdec xmm0, xmm1
	aesimc xmm1, [rsi+96]				;round key 6
	aesdec xmm0, xmm1
	aesimc xmm1, [rsi+80]				;round key 5
	aesdec xmm0, xmm1
	aesimc xmm1, [rsi+64]				;round key 4
	aesdec xmm0, xmm1
	aesimc xmm1, [rsi+48]				;round key 3
	aesdec xmm0, xmm1
	aesimc xmm1, [rsi+32]				;round key 2
	aesdec xmm0, xmm1
	aesimc xmm1, [rsi+16]				;round key 1
	aesdec xmm0, xmm1
	aesdeclast xmm0, [rsi]				;key

	movdqu [rdi],xmm0					;overwrite state
	ret
	