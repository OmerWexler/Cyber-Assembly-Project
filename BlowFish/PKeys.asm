;===== PKeys Generation =====
macro generatePKeys
	pushAll
	
	call generatePKeys_PROC

	popAll
endm generatePKeys

proc generatePKeys_PROC
	
	initBasicProc 0
	
	;Stage 1 - Key data encryption using the given password.
	xor ax, ax
	xor di, di
	xor si, si
	
	mov cx, [keysArrayLength]
	GPK_passwordXorWithKeysIter_LABEL:
		cmp [password + si], 24h
		jne GPK_skipPasswordReset_LABEL
		
		xor si, si
		
	GPK_skipPasswordReset_LABEL:
		mov al, [password + si]
		xor al, [byte ptr PKeys + di]
		
		mov [byte ptr PKeys + di], al
		
		inc di
		inc si
		
	loop GPK_passwordXorWithKeysIter_LABEL
	
	;Stage 2 - encrypt the first 64 bits (8 bytes) with the PKeys 18 times
	;and replace two PKeys each time.  
	
	call preapareAlgorithm_PROC

	mov cx, 18d
	GPK_keyEncryptionWithBlowFish_LABEL:
		push cx
		mov di, cx
		
		call blowFishAlgorithmEncrypt_PROC	
		readFromDataBlockBuffer
		
		;move into the last key the reversed first 32 bits (and so on for the loop when only the PKeys change).
		transferIntoKey 'p', di, bx, ax
		
		;move into the first key the reversed second 32 bits (and so on for the loop when only the PKeys change).
		mov si, 19d
		sub si, di
		transferIntoKey 'p', si, dx, cx
		
		pop cx
	loop GPK_keyEncryptionWithBlowFish_LABEL
	
	call finishEncryption_PROC

	endBasicProc 0
	ret 0
endp generatePKeys_PROC 

;===== Key Creation =====
macro allocatePKeys
	
	call allocatePKeys_PROC
	
endm allocatePKeys

proc allocatePKeys_PROC
	
	initBasicProc 0

	;P1
	transferIntoKey 'p', 1, 1415h, 9265h
	
	;P2
	transferIntoKey 'p', 2, 3589h, 7932h
	
	;P3
	transferIntoKey 'p', 3, 3846h, 2643h
	
	;P4
	transferIntoKey 'p', 4, 3832h, 9265h
	
	;P5
	transferIntoKey 'p', 5, 2884h, 1971h
	
	;P6
	transferIntoKey 'p', 6, 6939h, 9375h
	
	;P7
	transferIntoKey 'p', 7, 1058h, 2097h
	
	;P8
	transferIntoKey 'p', 8, 4944h, 5923h
	
	;P9
	transferIntoKey 'p', 9, 0781h, 6406h
	
	;P10
	transferIntoKey 'p', 10, 2862h, 0899h
	
	;P11
	transferIntoKey 'p', 11, 2534h, 2117h
	
	;P12
	transferIntoKey 'p', 12, 0679h, 8214h
	
	;P13
	transferIntoKey 'p', 13, 8086h, 5132h
	
	;P14
	transferIntoKey 'p', 14, 8230h, 6647h
	
	;P15
	transferIntoKey 'p', 15, 0938h, 4460h
	
	;P16
	transferIntoKey 'p', 16, 9550h, 5822h
	
	;P17
	transferIntoKey 'p', 17, 3172h, 5359h
	
	;P18
	transferIntoKey 'p', 18, 4081h, 2848h

	endBasicProc 0
	ret 0
endp allocatePKeys_PROC