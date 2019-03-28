IDEAL
MODEL small
STACK 100h
DATASEG
include 'VarData.asm'
fileName db 'tester.txt'
filehandle db ?
string db 'STRING'

CODESEG
include 'BaseLIB.asm'
include 'FilesLIB.asm'

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

proc BlowFishAlgorithm_PROC
	
	InitBasicProc 0
	
	
	EndBasicProc 0 
	ret 0
endp BlowFishAlgorithm_PROC

start:
	mov ax, @data
	mov ds, ax
	
	OpenFile fileName, filehandle, 'b'
	ReadFromFile filehandle, 65d, string
exit:
mov ax, 4C00h
int 21h
END start