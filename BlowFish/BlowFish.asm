IDEAL
MODEL small
STACK 100h
DATASEG
include 'VarData.asm'

CODESEG
include 'BaseLIB.asm'
include 'FilesLIB.asm'

proc generateKeys_PROC
	
	InitBasicProc 0
	xor ax, ax
	xor di, di
	xor si, si
	
	mov cx, [keysArrayLength]
	passwordXorIter:
		cmp [password + si], 24h
		jne skipPasswordReset
		
		xor si, si
		
    skipPasswordReset:
		mov al, [password + si]
		xor al, [keys + di]
		
		mov [keys + di], al
		
		inc di
		inc si
		
	loop passwordXorIter
	
	
	

		
	
	EndBasicProc 0
	ret 0
	
endp generateKeys_PROC

proc BlowFishAlgorithm_PROC
	
	InitBasicProc 0
	
	
	EndBasicProc 0 
	ret 0
endp BlowFishAlgorithm_PROC

start:
	mov ax, @data
	mov ds, ax
	call generateKeys_PROC
	call generateKeys_PROC
exit:
mov ax, 4C00h
int 21h
END start