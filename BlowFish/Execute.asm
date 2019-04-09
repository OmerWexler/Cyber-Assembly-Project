IDEAL
MODEL small
STACK 100h
DATASEG
include 'VarData.asm'

CODESEG
include 'BaseLIB.asm'
include 'FilesLIB.asm'
include 'BlowFish.asm'
include 'KeyFuncs.asm'



start:
	mov ax, @data
	mov ds, ax

	;mov ax, [word ptr keys]
	;mov bx, [word ptr keys + 1]
	;mov cx, [word ptr keys + 2]
	;mov dx, [word ptr keys + 3]
	
	TransferIntoKey 2

exit:
mov ax, 4C00h
int 21h
END start