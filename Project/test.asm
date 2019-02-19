IDEAL
MODEL small
STACK 100h

DATASEG

include "Vars.asm"


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
	
	;SwitchGraphicsMode 'g'
	;SetPixel 10d, 20, 100 
	;GetPixelIntoVar 20, 100, toPrint2
	;SwitchGraphicsMode 't'
	
;UtilLIB 1/2
	;SetCursorPos 0, 14d
	;WaitTime 3
	
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
	
;FilesLIB 1/1
	CreateFile File1, File1H
	OpenFile File1, File1H,'b'
	CloseFile File1H
	OpenFile File1, File1H,'b'
	WriteToFile File1H, PrintAble
	
	ReadFromFile File1H, readLengh, toPrint
	
	Print toPrint
	
	CloseFile File1H
	WaitForInput
	
	DeleteFile File1
	
	
exit:
mov ax, 4C00h
int 21h
END start