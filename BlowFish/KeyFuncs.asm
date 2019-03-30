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
		xor al, [keys + di]
		
		mov [keys + di], al
		
		inc di
		inc si
		
	loop passwordXorWithKeysIter
	
	
	

		
	
	EndBasicProc 0
	ret 0
	
endp generateKeys_PROC