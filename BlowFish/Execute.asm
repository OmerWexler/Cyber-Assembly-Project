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

;===== Debugging tool =====
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

;===== Debugging tool =====
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

;===== Debugging tool =====
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

;===== Debugging tool =====
macro setMouse X, Y

	mov ax, X
	mov [mouseX], ax
	
	mov ax, Y
	mov [mouseY], ax
	
endm setMouse

macro prepareRun

	switchGraphicsMode 'g'
		
	initMouse
	showMouse
		
	printBMP

endm prepareRun
start:
	mov ax, @data
	mov ds, ax
	
	prepareRun	

	EXE_OpeningScreen_LABEL:

		setButton [backEnabled], [true]
		setButton [nextEnabled], [false]
		setButton [decryptEnabled], [true]
		setButton [encryptEnabled], [true]
		setButton [restartEnabled], [false]

		OPS_OpeningScreenLoop_LABEL:
			manageCurrentScreen decryptButton, EXE_Decryption_LABEL, encryptButton, EXE_Encryption_LABEL
				jmp OPS_OpeningScreenLoop_LABEL


	EXE_Decryption_LABEL:
	EXE_Encryption_LABEL:





exit:
mov ax, 4C00h
int 21h
end start 