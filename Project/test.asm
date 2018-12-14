IDEAL
MODEL small
STACK 100h
DATASEG

File1 db 'test1.txt', 0
File1H dw ?

PrintAble db 'Print macro works', '$'


CODESEG

include 'Library.asm'

proc try


	ret
endp try

start:
	mov ax, @data
	mov ds, ax
	
	;GraphLIB
	SwitchGraphicsMode 1h
	Print PrintAble
	
	SwitchGraphicsMode 0h
	Print PrintAble
	
	ClearScreen
	
	;UtilLIB 1/2
	SetCursorPos 0, 14d
	
	;BaseLIB 1/1
	InitBasicProc 0
	EndBasicProc 0
	
	InitFunction 0
	EndFunction 0
	
	Print PrintAble
	
	;UtilLIB 2/2
	ClearScreen
	
	;InOutLIB 1/1
	WaitForInput
	
	;FilesLIB 1/1
	CreateFile File1, File1H
	
exit:

mov ax, 4C00h
int 21h
END start



