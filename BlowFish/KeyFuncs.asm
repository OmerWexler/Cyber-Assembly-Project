proc generateKeys_PROC
	
	InitBasicProc 0
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
	
	OpenFile currentFileName, currentFileHandle, 'b'
	ReadFromFile currentFileHandle, 8d, dataBlockBuffer

	RunBlowFishALG
	
	mov al ,[byte ptr dataBlockBuffer]
	
	EndBasicProc 0
	ret 0
	
endp generateKeys_PROC


;===== Tranfer Into Key Function =====
macro TransferIntoKey keyID, LowWord, HighWord
	InitFunction
	
	push keyID
	push LowWord
	push HighWord
	call TransferIntoKey_PROC

	EndFunction
endm TransferIntoKey

TIK_key_VAR equ bp + 8
TIK_LowWord_VAR equ bp + 6
TIK_HighWord_VAR equ bp + 4
proc TransferIntoKey_PROC 
	InitBasicProc 0

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

	EndBasicProc 0
	ret 6
endp TransferIntoKey_PROC 


;===== Read Key =====
macro ReadFromKey keyID
	InitFunction
	
	push keyID
	call ReadFromKey_PROC

	EndFunction
endm ReadFromKey

RFK_KeyID_VAR equ bp + 4
proc ReadFromKey_PROC 
	InitBasicProc 0	
	
	xor di, di
	xor ax, ax

	mov di, [RFK_KeyID_VAR]
	dec di

	mov ax, 4d  
	mul di
	mov di, ax
	
	mov ax, [word ptr keys + di]
	mov dx, [word ptr keys + di + 2d]

	
	EndBasicProc 0
	ret 6
endp ReadFromKey_PROC

;===== Key Creation =====
macro AllocateKeys
	InitFunction

	call AllocateKeys_PROC

	EndFunction
endm AllocateKeys

proc AllocateKeys_PROC
	InitBasicProc 0

	;P1
	TransferIntoKey 1, 1415h, 9265h
	
	;P2
	TransferIntoKey 2, 3589h, 7932h
	
	;P3
	TransferIntoKey 3, 3846h, 2643h
	
	;P4
	TransferIntoKey 4, 3832h, 9265h
	
	;P5
	TransferIntoKey 5, 2884h, 1971h
	
	;P6
	TransferIntoKey 6, 6939h, 9375h
	
	;P7
	TransferIntoKey 7, 1058h, 2097h
	
	;P8
	TransferIntoKey 8, 4944h, 5923h
	
	;P9
	TransferIntoKey 9, 0781h, 6406h
	
	;P10
	TransferIntoKey 10, 2862h, 0899h
	
	;P11
	TransferIntoKey 11, 2534h, 2117h
	
	;P12
	TransferIntoKey 12, 0679h, 8214h
	
	;P13
	TransferIntoKey 13, 8086h, 5132h
	
	;P14
	TransferIntoKey 14, 8230h, 6647h
	
	;P15
	TransferIntoKey 15, 0938h, 4460h
	
	;P16
	TransferIntoKey 16, 9550h, 5822h
	
	;P17
	TransferIntoKey 17, 3172h, 5359h
	
	;P18
	TransferIntoKey 18, 4081h, 2848h

	EndBasicProc 0
	ret 0
endp AllocateKeys_PROC