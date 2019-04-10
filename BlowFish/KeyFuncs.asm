;===== Tranfer Into Key Function =====
macro transferIntoKey keyID, LowWord, HighWord
	initFunction
	
	push keyID
	push LowWord
	push HighWord
	call transferIntoKey_PROC

	endFunction
endm transferIntoKey

TIK_key_VAR equ bp + 8
TIK_LowWord_VAR equ bp + 6
TIK_HighWord_VAR equ bp + 4
proc transferIntoKey_PROC 
	initBasicProc 0

	xor di, di
	xor ax, ax
	
	mov di, [TIK_key_VAR]
	dec di

	mov ax, 4d  
	mul di
	mov di, ax

	mov ax, [TIK_LowWord_VAR]
	mov [word ptr keys + di], ax
	mov ax, [TIK_HighWord_VAR]
	mov [word ptr keys + di + 2d], ax

	endBasicProc 0
	ret 6
endp transferIntoKey_PROC

;===== Key Generation =====
macro generateKeys
	AllocateKeys

	initFunction

	call generateKeys_PROC
	
	endFunction
endm generateKeys

proc generateKeys_PROC
	
	initBasicProc 0
	
	;Stage 1 - Key data encryption using the given password.
	xor ax, ax
	xor di, di
	xor si, si
	
	mov cx, [keysArrayLength]
	passwordXorWithKeysIter:
		cmp [password + si], 24h
		jne skipPasswordReset
		
		xor si, si
		
    skipPasswordReset:
		mov al, [password + si]
		xor al, [byte ptr keys + di]
		
		mov [byte ptr keys + di], al
		
		inc di
		inc si
		
	loop passwordXorWithKeysIter
	
	;Stage 2 - encrypt the first 64 bits (8 bytes) with the keys 18 times
	;and replace two keys each time.  
	openFile currentFileName, currentFileHandle, 'b'
	readFromFile currentFileHandle, 8d, dataBlockBuffer
	
	mov cx, 18d
	keyEncryptionWithBlowFish_LABEL:
		push cx

		runBlowFishALG	
		readFromDataBlock
		
		transferIntoKey cx, bx, ax
		sub cx, 18d
		transferIntoKey cx, dx, cx
		
		pop cx

	loop keyEncryptionWithBlowFish_LABEL

	endBasicProc 0
	ret 0
	
endp generateKeys_PROC 

;===== Read Key =====
macro readFromKey keyID
	initFunction
	
	push keyID
	call readFromKey_PROC

	endFunction
endm readFromKey

RFK_KeyID_VAR equ bp + 4
proc readFromKey_PROC 
	initBasicProc 0	
	
	xor di, di
	xor ax, ax

	mov di, [RFK_KeyID_VAR]
	dec di

	mov ax, 4d  
	mul di
	mov di, ax
	
	mov ax, [word ptr keys + di]
	mov dx, [word ptr keys + di + 2d]

	
	endBasicProc 0
	ret 6
endp readFromKey_PROC

;===== Key Creation =====
macro AllocateKeys
	initFunction

	call AllocateKeys_PROC

	endFunction
endm AllocateKeys

proc AllocateKeys_PROC
	initBasicProc 0

	;P1
	transferIntoKey 1, 1415h, 9265h
	
	;P2
	transferIntoKey 2, 3589h, 7932h
	
	;P3
	transferIntoKey 3, 3846h, 2643h
	
	;P4
	transferIntoKey 4, 3832h, 9265h
	
	;P5
	transferIntoKey 5, 2884h, 1971h
	
	;P6
	transferIntoKey 6, 6939h, 9375h
	
	;P7
	transferIntoKey 7, 1058h, 2097h
	
	;P8
	transferIntoKey 8, 4944h, 5923h
	
	;P9
	transferIntoKey 9, 0781h, 6406h
	
	;P10
	transferIntoKey 10, 2862h, 0899h
	
	;P11
	transferIntoKey 11, 2534h, 2117h
	
	;P12
	transferIntoKey 12, 0679h, 8214h
	
	;P13
	transferIntoKey 13, 8086h, 5132h
	
	;P14
	transferIntoKey 14, 8230h, 6647h
	
	;P15
	transferIntoKey 15, 0938h, 4460h
	
	;P16
	transferIntoKey 16, 9550h, 5822h
	
	;P17
	transferIntoKey 17, 3172h, 5359h
	
	;P18
	transferIntoKey 18, 4081h, 2848h

	endBasicProc 0
	ret 0
endp AllocateKeys_PROC