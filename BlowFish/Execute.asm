IDEAL
MODEL small
STACK 100h
DATASEG
include 'VarData.asm'

CODESEG
include 'BaseLIB.asm'
include 'Booleans.asm'
include 'FilesLIB.asm'
include 'GenKeys.asm'
include 'BlowFish.asm'
include 'PKeys.asm'
include 'FKeys.asm'
include 'Function.asm'
include 'General.asm'

macro initAllKeys 

	allocatePKeys
	allocateFKeys

	openFile currentFileName, currentFileHandle, 'b' 

	generatePKeys
	resetCurrentFilePointer

	generateFKeys
	resetCurrentFilePointer 

endm initAllKeys

macro setCurrentFileToTester
	mov [currentFileName + 0], 't'
	mov [currentFileName + 1], 'e'
	mov [currentFileName + 2], 's'
	mov [currentFileName + 3], 't'
	mov [currentFileName + 4], 'e'
	mov [currentFileName + 5], 'r'
	mov [currentFileName + 6], '.'
	mov [currentFileName + 7], 't'
	mov [currentFileName + 8], 'x'
	mov [currentFileName + 9], 't'
	mov [currentFileName + 10], 0

	mov [currentFileNameLength], 10d
endm setCurrentFileToTester

start:
	mov ax, @data
	mov ds, ax

	setCurrentFileToTester

	initAllKeys
	createDataFile

exit:
mov ax, 4C00h
int 21h
END start