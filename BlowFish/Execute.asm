.386
IDEAL
MODEL small
STACK 100h
DATASEG
include 'VarData.asm'

CODESEG
include 'BaseLIB.asm'
include 'Booleans.asm'
include 'InOut.asm'
include 'FilesLIB.asm'
include 'GenKeys.asm'
include 'Function.asm'
include 'Password.asm'
include 'Filename.asm'
include 'Datafile.asm'
include 'BlowFish.asm'
include 'PKeys.asm'
include 'FKeys.asm'
include 'Graphics.asm'
include 'Screens.asm'
include 'Buttons.asm'

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

macro setCurrentReadFileToEarth
	mov [currentReadFileName + 0], 'E'
	mov [currentReadFileName + 1], 'a'
	mov [currentReadFileName + 2], 'r'
	mov [currentReadFileName + 3], 't'
	mov [currentReadFileName + 4], 'h'
	mov [currentReadFileName + 5], '.'
	mov [currentReadFileName + 6], 'm'
	mov [currentReadFileName + 7], 'p'
	mov [currentReadFileName + 8], '4'
	mov [currentReadFileName + 9], 0

endm setCurrentReadFileToEarth

macro setMouse X, Y

	mov ax, X
	mov [mouseX], ax
	
	mov ax, Y
	mov [mouseY], ax
	
endm setMouse

start:
	mov ax, @data
	mov ds, ax

	; setCurrentReadFileToEarth
	
	; copyFileTypeToAlgorithmFiles currentReadFileName

	; initAllKeys

	; resetCurrentReadFilePointer

	; runAlgorithm 'E'

	; createDataFile

	; retrieveDataFile

	; copyFileName currentReadFileName, encryptedFileName

	; runAlgorithm 'D'
	
	switchGraphicsMode 'g'
	
	initMouse
	
	showMouse
		
	printBMP

	setButton [backEnabled], [true]
	setButton [nextEnabled], [true]
	setButton [decryptEnabled], [false]
	setButton [encryptEnabled], [false]
	setButton [restartEnabled], [false]

	; setMouse 20, 180
	; call updateButtons_PROC

	; setMouse 300, 150
	; call updateButtons_PROC	

	l:
		readMouse
		call runScreen_PROC
		jmp l
	; waitForKeyboardInput

exit:
mov ax, 4C00h
int 21h
end start 