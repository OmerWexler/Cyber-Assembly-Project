IDEAL
MODEL small
STACK 100h
DATASEG
include 'VarData.asm'

CODESEG
include 'BaseLIB.asm'
include 'FilesLIB.asm'
include 'KeyFuncs.asm'
include 'BlowFish.asm'



start:
	mov ax, @data
	mov ds, ax
	
	OpenFile TESTER, TESTER_HANDLE, 'b'
	ReadFromFile TESTER_HANDLE, 65d, readBuffer
	
	mov [readBuffer + 65d], ' '
	mov [readBuffer + 66d], ' '
	mov [readBuffer + 67d], ' '
	mov [readBuffer + 68d], ' '
	mov [readBuffer + 69d], '$'

	
	WriteToFile TESTER_HANDLE, readBuffer
exit:
mov ax, 4C00h
int 21h
END start