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
include 'Graphics.asm'
include 'BlowFish.asm'
include 'PKeys.asm'
include 'FKeys.asm'
include 'Screens.asm'
include 'Buttons.asm'
include 'Strings.asm'

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

start:
	mov ax, @data
	mov ds, ax

	xor di, di

	switchGraphicsMode 'g'
		
	initMouse
	showMouse	
	
	printScreen
	
	createDataFile ;REMOVE AFTER DECRYPTION TESTING
	
	startA:
		calculateAndPrintProgress 160, 100
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

			setupButtons [false], [false], [false], [false], [false]
			clearKeyboardBuffer

			DEC_Name_LOOP: ;=== Name Empty Loop ===
				
				manageCurrentScreen backButton, DEC_Intro_LABEL, nextButton, DEC_Password_LABEL

				readStringFromKeyboardITER currentReadFileName, readFileLengthLimit
				checkBoolean [boolFlag], DEC_ValidateName_LABEL, DEC_Name_LOOP
				
				DEC_ValidateName_LABEL:
						printString currentReadFileName, 88d, 138d

						validateFile currentReadFileName
						checkBoolean [boolFlag], DEC_NameValid_LABEL, DEC_NameInValid_LABEL
						
					jmp DEC_Name_LOOP 
					
			DEC_NameInValid_LABEL: ;=== Name InValid ===
				setupButtons [false], [false], [false], [false], [false]
				setNextScreenProperty status, STATUS_InputInvalid
				
				printScreen
				printString currentReadFileName, 88d, 138d
				
				jmp DEC_Name_LOOP
						
			DEC_NameValid_LABEL:  ;=== Name Valid ===
				setNextScreenProperty status, STATUS_InputValid

				printScreen
				printString currentReadFileName, 88d, 138d

				setupButtons [true], [true], [false], [false], [false]
				
				DEC_NameValid_Loop:
					manageCurrentScreen nextButton, DEC_Password_LABEL, backButton, DEC_Intro_LABEL
					
					DEC_SkipNameRefresh_LABEL:
						readStringFromKeyboardITER currentReadFileName, readFileLengthLimit
						checkBoolean [boolFlag], DEC_ReValidateName_LABEL, DEC_NameValid_Loop
					
					DEC_ReValidateName_LABEL:
							printScreen
							printString currentReadFileName, 88d, 138d

							validateFile currentReadFileName
							checkBoolean [boolFlag], DEC_NameValid_Loop, DEC_NameInValid_LABEL
									
		DEC_Password_LABEL: ;===== Password =====
			
			retrieveDataFile
			setupButtons [false], [false], [false], [false], [false]
			resetStringReadIndex

			DEC_Password_Loop: ;=== Password Empty Loop ===
				
			manageCurrentScreen backButton, DEC_Intro_LABEL, nextButton, DEC_Password_LABEL
						
			readStringFromKeyboardITER insertedPassword, passwordLengthLimit
			checkBoolean [boolFlag], DEC_ValidatePassword_LABEL, DEC_Password_Loop
						
			DEC_ValidatePassword_LABEL:					
					printString insertedPassword, 93d, 138d

					compareStrings password, insertedPassword 
					checkBoolean [boolFlag], DEC_PasswordValid_LABEL, DEC_PasswordInValid_LABEL
					
				jmp DEC_Password_Loop 

			DEC_PasswordValid_LABEL: ;=== Password Valid Loop ===
				setupButtons [true], [true], [false], [false], [false]
				setNextScreenProperty status, STATUS_InputValid
				
				printScreen
				printString insertedPassword, 93d, 138d
				
				DEC_PasswordValid_LOOP:
				
						manageCurrentScreen nextButton, DEC_Loading_LABEL, backButton, DEC_Name_LABEL
						
						isAnyButtonLit
						pop ax
						compare ax, '!=', nextButton
						checkBooleanSingleJump [boolFlag], DEC_SkipPasswordRefresh_LABEL
						
						printString insertedPassword, 93d, 138d

					DEC_SkipPasswordRefresh_LABEL:
						readStringFromKeyboardITER insertedPassword, readFileLengthLimit
						checkBoolean [boolFlag], DEC_ReValidatePassword_LABEL, DEC_PasswordValid_LOOP
					
					DEC_ReValidatePassword_LABEL:
							printScreen
							printString insertedPassword, 93d, 138d
							
							compareStrings password, insertedPassword 
							checkBoolean [boolFlag], DEC_Password_Loop, DEC_PasswordInValid_LABEL
							

			DEC_PasswordInValid_LABEL: ;=== Password Invalid ===
				setupButtons [false], [false], [false], [false], [false]
				setNextScreenProperty status, STATUS_InputInvalid
				
				printScreen
				printString insertedPassword, 93d, 138d
				
				jmp DEC_Password_Loop
			
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