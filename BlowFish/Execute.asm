IDEAL
MODEL small
STACK 100h
DATASEG
include 'VarData.asm'

CODESEG
include 'BaseLIB.asm'
include 'FilesLIB.asm'
include 'MiscFunc.asm'
include 'BlowFish.asm'
include 'KeyFuncs.asm'




start:
	mov ax, @data
	mov ds, ax

	allocateKeys
	generateKeys

exit:
mov ax, 4C00h
int 21h
END start