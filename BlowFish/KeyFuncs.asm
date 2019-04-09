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

proc AllocateKeys_PROC
	InitBasicProc 0

	;P1
	mov ax, 1415h
	mov [word ptr keys], ax
	mov ax, 9265h
	mov [word ptr keys + 1 * 2], ax

	;P2
	mov ax, 3589h
	mov [word ptr keys], ax
	mov ax, 7932h
	mov [word ptr keys + 1 * 2], ax
	
	;P3
	mov ax, 3846h
	mov [word ptr keys], ax
	mov ax, 2643h
	mov [word ptr keys + 1 * 2], ax
	;P4
	mov ax, 3832h
	mov [word ptr keys], ax
	mov ax, 9265h
	mov [word ptr keys + 1 * 2], ax
	
	;P5
	mov ax, 2884h
	mov [word ptr keys], ax
	mov ax, 1971h
	mov [word ptr keys + 1 * 2], ax
	
	;P6
	mov ax, 6939h
	mov [word ptr keys], ax
	mov ax, 9375h
	mov [word ptr keys + 1 * 2], ax
	
	;P7
	mov ax, 1058h
	mov [word ptr keys], ax
	mov ax, 2097h
	mov [word ptr keys + 1 * 2], ax
	
	;P8
	mov ax, 4944h
	mov [word ptr keys], ax
	mov ax, 5923h
	mov [word ptr keys + 1 * 2], ax
	
	;P9
	mov ax, 0781h
	mov [word ptr keys], ax
	mov ax, 6406h
	mov [word ptr keys + 1 * 2], ax
	
	;P10
	mov ax, 2862h
	mov [word ptr keys], ax
	mov ax, 0899h
	mov [word ptr keys + 1 * 2], ax
	
	;P11
	mov ax, 2534h
	mov [word ptr keys], ax
	mov ax, 2117h
	mov [word ptr keys + 1 * 2], ax
	
	;P12
	mov ax, 0679h
	mov [word ptr keys], ax
	mov ax, 8214h
	mov [word ptr keys + 1 * 2], ax
	
	;P13
	mov ax, 8086h
	mov [word ptr keys], ax
	mov ax, 5132h
	mov [word ptr keys + 1 * 2], ax
	
	;P14
	mov ax, 8230h
	mov [word ptr keys], ax
	mov ax, 6647h
	mov [word ptr keys + 1 * 2], ax
	
	;P15
	mov ax, 0938h
	mov [word ptr keys], ax
	mov ax, 4460h
	mov [word ptr keys + 1 * 2], ax
	
	;P16
	mov ax, 9550h
	mov [word ptr keys], ax
	mov ax, 5822h
	mov [word ptr keys + 1 * 2], ax
	
	;P17
	mov ax, 3172h
	mov [word ptr keys], ax
	mov ax, 5359h
	mov [word ptr keys + 1 * 2], ax
	
	;P18
	mov ax, 4081h
	mov [word ptr keys], ax
	mov ax, 2848h
	mov [word ptr keys + 1 * 2], ax

	EndBasicProc 0
	ret 0
endp AllocateKeys_PROC

;===== Tranfer Into Key Function =====
macro TransferIntoKey keyID
	InitFunction
	
	push keyID
	call TransferIntoKey_PROC

	EndFunction
endm TransferIntoKey

TIK_Key_VAR equ bp + 4
proc TransferIntoKey_PROC 
	InitBasicProc 0

	mov di, [TIK_Key_VAR]
	dec di

	mov al, 8d  
	mul di
	mov di, ax

	mov al, 0000h
	mov [word ptr keys + di], ax
	mov al, 0000h
	mov [word ptr keys + di + 4d], ax

	EndBasicProc 0
	ret 2 
endp TransferIntoKey_PROC 