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

macro setCurrentReadFileToGold
	mov [currentReadFileName + 0], 'G'
	mov [currentReadFileName + 1], 'o'
	mov [currentReadFileName + 2], 'l'
	mov [currentReadFileName + 3], 'd'
	mov [currentReadFileName + 4], '.'
	mov [currentReadFileName + 5], 'm'
	mov [currentReadFileName + 6], 'p'
	mov [currentReadFileName + 7], '3'
	mov [currentReadFileName + 8], 0

endm setCurrentReadFileToGold

start:
	mov ax, @data
	mov ds, ax
	
	setCurrentReadFileToTester
	
	copyFileTypeToAlgorithmFiles currentReadFileName

	initAllKeys

	resetCurrentReadFilePointer

	runAlgorithm 'E'

	; createDataFile

	; retrieveDataFile

	copyFileName currentReadFileName, encryptedFileName

	runAlgorithm 'D'

exit:
mov ax, 4C00h
int 21h
END start 