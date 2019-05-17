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
include 'Function.asm'
include 'General.asm'
include 'BlowFish.asm'
include 'PKeys.asm'
include 'FKeys.asm'
include 'Graphics.asm'

macro initAllKeys 

	allocatePKeys
	allocateFKeys

	generatePKeys
	resetCurrentReadFilePointer

	generateFKeys
	resetCurrentReadFilePointer 

endm initAllKeys

macro setCurrentReadFileToTester
	mov [currentReadFileName + 0], 't'
	mov [currentReadFileName + 1], 'e'
	mov [currentReadFileName + 2], 's'
	mov [currentReadFileName + 3], 't'
	mov [currentReadFileName + 4], 'e'
	mov [currentReadFileName + 5], 'r'
	mov [currentReadFileName + 6], '.'
	mov [currentReadFileName + 7], 't'
	mov [currentReadFileName + 8], 'x'
	mov [currentReadFileName + 9], 't'
	mov [currentReadFileName + 10], 0

endm setCurrentReadFileToTester

macro setCurrentReadFileToENCRYPTE
	mov [currentReadFileName + 0], 'E'
	mov [currentReadFileName + 1], 'N'
	mov [currentReadFileName + 2], 'C'
	mov [currentReadFileName + 3], 'R'
	mov [currentReadFileName + 4], 'Y'
	mov [currentReadFileName + 5], 'P'
	mov [currentReadFileName + 6], 'T'
	mov [currentReadFileName + 7], 'E'
	mov [currentReadFileName + 8], '.'
	mov [currentReadFileName + 9], 't'
	mov [currentReadFileName + 10], 'x'
	mov [currentReadFileName + 11], 't'
	mov [currentReadFileName + 12], 0

endm setCurrentReadFileToENCRYPTE

start:
	mov ax, @data
	mov ds, ax
	
	; setCurrentReadFileToTester

	; initAllKeys

	; resetCurrentReadFilePointer

	; runAlgorithm 'E'

	; createDataFile

	retrieveDataFile

	setCurrentReadFileToENCRYPTE

	runAlgorithm 'D'

exit:
mov ax, 4C00h
int 21h
END start 