IDEAL
MODEL small
STACK 100h

DATASEG

File1 db 'testfile.txt', 0,'$'
File1H dw ?

PrintAble db 'Print macro works ','$'


CODESEG
include 'Library.asm'

start:
	mov ax, @data
	mov ds, ax
	
	;GraphLIB
	;SwitchGraphicsMode 't'
	;Print PrintAble
	
	;SwitchGraphicsMode 'g'
	;Print PrintAble
	
	;ClearScreen
	
	;UtilLIB 1/2
	;SetCursorPos 0, 14d
	
	;BaseLIB 1/1
	;InitBasicProc 0
	;EndBasicProc 0
	
	;InitFunction 0
	;EndFunction 0
	
	;Print PrintAble
	;PrintChar 'E'
	
	;UtilLIB 2/2
	;ClearScreen
	
	;SwitchGraphicsMode 't'
	
	;InOutLIB 1/1
	;WaitForInput
	
	FilesLIB 1/1
	CreateFile File1, File1H
	OpenFile File1, File1H,'b'
	WriteToFile File1H, PrintAble
	SeekFile File1H, 0d, 20d, 's'
	WriteToFile File1H, PrintAble
	
	CloseFile File1H
	;WaitForInput
	
	;DeleteFile File1
	
	
exit:
mov ax, 4C00h
int 21h
END start




