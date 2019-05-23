.386
IDEAL
MODEL small
STACK 100h
DATASEG
include 'Ascii.asm'
include 'VarData.asm'
include 'CharBMPs.asm'

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

	xor di, di

	prepareRun	
	
	printBMPCharacter 'S', 160d, 100d
	waitForKeyboardInput
	
	jmp exit
	EXE_OpeningScreen_LABEL: ;=====-===== Opening Screen ==========================================================================================================================================

		setupButtons [true], [false], [true], [true], [false]

		OPS_OpeningScreen_LOOP: ;=== Opening Screen Loop ===
			manageCurrentScreen decryptButton, EXE_Decryption_LABEL, encryptButton, EXE_Encryption_LABEL
			jmp OPS_OpeningScreen_LOOP


	EXE_Decryption_LABEL: ;=====-===== Decryption screen ==========================================================================================================================================
		
		DEC_Intro_LABEL: ;===== Intro =====
			
			setupButtons [true], [true], [false], [false], [false]
			
			DEC_Intro_LOOP:
				manageCurrentScreen backButton, EXE_OpeningScreen_LABEL, nextButton, DEC_Name_LABEL
				jmp DEC_Intro_LOOP
			
		DEC_Name_LABEL: ;===== Name Check =====

			setupButtons [true], [true], [false], [false], [false]

			DEC_NameEmpty_LOOP: ;=== Name Empty Loop ===
				
				manageCurrentScreen backButton, DEC_NameEmpty_LOOP, nextButton, DEC_NameEmpty_LOOP
				
				readStringFromKeyboardITER currentReadFileName, di, readFileLengthLimit
				pop di
			
				DEC_ValidateName_LABEL:
					mov [currentReadFileName + di + 1], 0d ; seals the file for validation
					validateFile currentReadFileName
					checkBoolean [boolFlag], DEC_NameInValid_LABEL, DEC_NameInValid_LABEL

					DEC_NameInValid_LABEL:
					setNextScreenProperty status, STATUS_InputInvalid


				jmp DEC_NameEmpty_LOOP
				

			; DEC_NameInValid_LABEL: ;=== Name InValid ===
				printBMP
				
				DEC_NameInValid_LOOP:
					
					manageCurrentScreen backButton, EXE_OpeningScreen_LABEL, nextButton, DEC_Name_LABEL
					jmp DEC_NameInValid_LOOP

			DEC_NameValid_LOOP: ;=== Name Valid Loop ===
				setNextScreenProperty status, STATUS_Inputvalid
				printBMP
				
		DEC_Password_LABEL: ;===== Password =====
			
			setupButtons [true], [true], [false], [false], [false]
		
			DEC_PasswordEmpty_LABEL: ;=== Password Empty Loop ===
			DEC_PasswordInvalid_LOOP: ;=== Password Invalid Loop ===
			DEC_PasswordValid_LOOP: ;=== Password Valid Loop ===
			
		DEC_Loading_LABEL: ;===== Loading Screen =====
			
			setupButtons [false], [true], [false], [false], [false]

			DEC_LoadingEmpty_LOOP: ;=== Loading Empty Loop ===
			DEC_LoadingLoaded_LOOP: ;=== Loading Loaded Loop ===
			
		DEC_EndGame_LABEL: ;===== End Game *SNAP* =====
	
			setupButtons [true], [false], [false], [false], [true]

			DEC_EndGame_LOOP: ;=== End Game *SNAP Loop ===
			

	EXE_Encryption_LABEL: ;=====-===== Encryption Screens ==========================================================================================================================================


exit:
mov ax, 4C00h
int 21h
end start 