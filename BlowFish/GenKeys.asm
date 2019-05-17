;===== Tranfer Into Key Function =====
macro transferIntoKey KeyType, keyID, LowWord, HighWord
	pushAll

	push KeyType
	push keyID
	push LowWord
	push HighWord
	call transferIntoKey_PROC
	
	popAll
endm transferIntoKey

TIK_keyType_VAR equ bp + 10
TIK_key_VAR equ bp + 8
TIK_LowWord_VAR equ bp + 6
TIK_HighWord_VAR equ bp + 4
proc transferIntoKey_PROC 
	
	initBasicProc 0

	push dx
	push di
	push ax

	xor di, di
	xor ax, ax
	
	mov di, [TIK_key_VAR]
	dec di

	mov ax, 4d  
	mul di
	mov di, ax

	xor ax, ax
	mov ax, [TIK_keyType_VAR]

	cmp ax, 122d
	je TIK_P_LABEL

	cmp ax, 102d
	je TIK_F_LABEL

TIK_P_LABEL:
	add di, offset PKeys
	jmp TIK_Continue_LABEL

TIK_F_LABEL:
	add di, offset Fkeys
	jmp TIK_Continue_LABEL

TIK_Continue_LABEL:

	mov ax, [TIK_LowWord_VAR]
	mov [word ptr di], ax
	mov ax, [TIK_HighWord_VAR]
	mov [word ptr di + 2d], ax

	pop ax
	pop di
	pop dx
	
	endBasicProc 0
	ret 8
endp transferIntoKey_PROC

;===== Read Key =====
;Moves low word into ax, high into dx.
macro readFromKey keyType, keyID

	push keyType
	push keyID
	call readFromKey_PROC

endm readFromKey

RFK_keyType_VAR equ bp + 6
RFK_KeyID_VAR equ bp + 4
proc readFromKey_PROC 
	initBasicProc 0	
	
	push di

	xor di, di

	mov di, [RFK_KeyID_VAR]
	dec di

	mov ax, 4d  
	mul di
	mov di, ax
	
	xor ax, ax
	mov ax, [RFK_keyType_VAR]

	cmp ax, 122d
	je RFK_P_LABEL

	cmp ax, 102d
	je RFK_F_LABEL

RFK_P_LABEL:
	add di, offset PKeys
	jmp RFK_Continue_LABEL

RFK_F_LABEL:
	add di, offset Fkeys
	jmp RFK_Continue_LABEL

RFK_Continue_LABEL:
	mov ax, [word ptr di]
	mov dx, [word ptr di + 2d]

	pop di

	endBasicProc 0
	ret 4
endp readFromKey_PROC