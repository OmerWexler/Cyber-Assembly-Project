;===== PKeys Generation =====
macro generatePKeys
	pushAll
	
	openFile currentReadFileName, currentReadFileHandle, 'r' 

	call generatePKeys_PROC

	closeFile [currentReadFileHandle]

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
		mov al, [byte ptr password + si]
		compare ax, '==' ,00d
		checkBoolean [boolFlag], GPK_XorPasswordWithArray_LABEL, GPK_ResetPasswordIndex_LABEL  
		
		GPK_ResetPasswordIndex_LABEL:
			xor si, si
			jmp GPK_XorPasswordWithArray_LABEL

		GPK_XorPasswordWithArray_LABEL:
			mov al, [password + si]
			xor al, [byte ptr PKeys + di]
			
			mov [byte ptr PKeys + di], al
			
			inc di
			inc si
			
	loop GPK_passwordXorWithKeysIter_LABEL
	
	;Stage 2 - encrypt the first 64 bits (8 bytes) with the PKeys 18 times
	;and replace two PKeys each time.
	
	prepareAlgorithm
	add sp, 2 ;To compensate for not taking the variable fron the stack

	mov cx, 18d
	GPK_keyEncryptionWithBlowFish_LABEL:
		push cx
		mov di, cx
		
		;Encrypt the new data block and update it from streams
		call blowFishAlgorithmEncrypt_PROC
		mov ax, [word ptr LStream]
		mov [word ptr dataBlockBuffer], ax
		
		mov ax, [word ptr LStream + 2d]
		mov [word ptr dataBlockBuffer + 2d], ax
		
		mov ax, [word ptr RStream]
		mov [word ptr dataBlockBuffer + 4d], ax
		
		mov ax, [word ptr RStream + 2d]
		mov [word ptr dataBlockBuffer + 6d], ax

		;move into the last key the reversed first 32 bits (and so on for the loop when only the PKeys change).
		mov ax, [word ptr dataBlockBuffer]
		mov dx, [word ptr dataBlockBuffer + 2d]
		transferIntoKey 'p', di, dx, ax
		
		;move into the first key the reversed second 32 bits (and so on for the loop when only the PKeys change).
		mov si, 19d
		sub si, di

		mov ax, [word ptr dataBlockBuffer + 4d]
		mov dx, [word ptr dataBlockBuffer + 6d]
		transferIntoKey 'p', si, dx, ax
		
		pop cx
	loop GPK_keyEncryptionWithBlowFish_LABEL

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