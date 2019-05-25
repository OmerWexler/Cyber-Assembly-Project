.386
IDEAL
MODEL small
STACK 100h
DATASEG
include 'Ascii.asm'
include 'VarData.asm'

CODESEG
include 'BaseLIB.asm'
include 'Booleans.asm'
include 'FilesLIB.asm'
include 'InOut.asm'
include 'GenKeys.asm'
include 'Function.asm'
include 'Password.asm'
include 'Filename.asm'
include 'Datafile.asm'
include 'Strings.asm'
include 'Graphics.asm'
include 'BlowFish.asm'
include 'PKeys.asm'
include 'FKeys.asm'
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

macro resetStringPrintIndex stringToReset

	mov [byte ptr stringToReset], 00d

endm resetStringPrintIndex

macro updatePasswordLength

	mov ax, [currentStringReadIndex]
	mov [passwordLength], ax

endm updatePasswordLength

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
	
	EXE_OpeningScreen_LABEL: ;=====-===== Opening Screen ==========================================================================================================================================
		
		setupButtons [true], [false], [true], [true], [false]
		enableStringBuffering [false]

		OPS_OpeningScreen_LOOP: ;=== Opening Screen Loop ===
			manageCurrentScreenTriButton decryptButton, EXE_Decryption_LABEL, encryptButton, EXE_Encryption_LABEL, backButton, exit
			jmp OPS_OpeningScreen_LOOP

		EXE_Encryption_LABEL:
			setRunMode 'E'
			setNextScreenProperty sType, TYPE_Encryption
			jmp EXE_Intro_LABEL

		EXE_Decryption_LABEL: 
			setRunMode 'D'
			setNextScreenProperty sType, TYPE_Decryption
			jmp EXE_Intro_LABEL

		EXE_Intro_LABEL: ;===== Intro =====
			setupButtons [true], [true], [false], [false], [false]
			enableStringBuffering [false]

			EXE_Intro_LOOP:
				manageCurrentScreen backButton, EXE_OpeningScreen_LABEL, nextButton, EXE_Name_LABEL
				jmp EXE_Intro_LOOP
			
		EXE_Name_LABEL: ;===== Name Check =====
			setupButtons [true], [false], [false], [false], [false]
			enableStringBuffering [true]

			resetStringPrintIndex currentReadFileName
			resetStringReadIndex
			printString currentReadFileName, nameX, nameY

			printScreen
			clearKeyboardBuffer

			EXE_Name_LOOP: ;=== Name Empty Loop ===
				
				manageCurrentScreen backButton, EXE_Intro_LABEL, nextButton, EXE_Password_LABEL

				readStringFromKeyboardITER currentReadFileName, readFileLengthLimit, [true]

				checkBoolean [boolFlag], EXE_ValidateName_LABEL, EXE_Name_LOOP
				
				EXE_ValidateName_LABEL:
						printString currentReadFileName, nameX, nameY

						validateFile currentReadFileName
						checkBoolean [boolFlag], EXE_NameValid_LABEL, EXE_NameInValid_LABEL
						
					jmp EXE_Name_LOOP 
					
				EXE_NameInValid_LABEL: 
					setupButtons [true], [false], [false], [false], [false]
					enableStringBuffering [true]

					setNextScreenProperty status, STATUS_InputInvalid
					
					printScreen
					printString currentReadFileName, nameX, nameY
					
					jmp EXE_Name_LOOP
							
				EXE_NameValid_LABEL:
					setNextScreenProperty status, STATUS_InputValid
					enableStringBuffering [true]

					printScreen
					printString currentReadFileName, nameX, nameY
					setupButtons [true], [true], [false], [false], [false]
					
					jmp EXE_Name_LOOP
				

									
		EXE_Password_LABEL: ;===== Password =====
			setupButtons [true], [false], [false], [false], [false]
			enableStringBuffering [true]

			resetStringPrintIndex insertedPassword
			resetStringReadIndex
			printString insertedPassword, nameX, nameY
			
			compare [runMode], '==', 'E'
			checkBooleanSingleJump [boolFlag], EXE_SkipDataFileRetrieve_LABEL
			
			validateFile dataFileName
			flipBoolFlag
			checkBooleanSingleJump [boolFlag], EXE_RequestDataFile_LABEL

			retrieveDataFile
			
			EXE_SkipDataFileRetrieve_LABEL:

			resetStringReadIndex

			EXE_Password_Loop: 
				
				manageCurrentScreen backButton, EXE_Name_LABEL, nextButton, EXE_Loading_LABEL
							
				readStringFromKeyboardITER insertedPassword, passwordLengthLimit, [false]
				checkBoolean [boolFlag], EXE_ValidatePassword_LABEL, EXE_Password_Loop
				
				EXE_ValidatePassword_LABEL:
					printString insertedPassword, passwordX, passwordY
				
					compare [runMode], '==', 'D'
					checkBooleanSingleJump [boolFlag], EXE_ComparePasswordToDataFile_LABEL
					
					updatePasswordLength
					
					validateString insertedPassword, [false]
					checkBoolean [boolFlag], EXE_PasswordValid_LABEL, EXE_PasswordInValid_LABEL

					EXE_ComparePasswordToDataFile_LABEL:
					
						compare [passwordLength], '!=', [currentStringReadIndex]
						checkBooleanSingleJump [boolFlag], EXE_PasswordInValid_LABEL
						
						compareStrings password, insertedPassword
						checkBoolean [boolFlag], EXE_PasswordValid_LABEL, EXE_PasswordInValid_LABEL

				EXE_PasswordValid_LABEL: ;=== Password Valid Loop ===
					enableStringBuffering [true]
					setupButtons [true], [true], [false], [false], [false]
					setNextScreenProperty status, STATUS_InputValid
					
					printScreen
					printString insertedPassword, passwordX, passwordY
					
					jmp EXE_Password_Loop

				EXE_PasswordInValid_LABEL: ;=== Password Invalid ===
					enableStringBuffering [true]
					setupButtons [true], [false], [false], [false], [false]
					setNextScreenProperty status, STATUS_InputInvalid
					
					printScreen
					printString insertedPassword, passwordX, passwordY
					
					jmp EXE_Password_Loop

				EXE_RequestDataFile_LABEL:
					setupButtons [true], [false], [false], [false], [false]
					enableStringBuffering [false]
					setNextScreenProperty status, STATUS_NoDataFile
					printScreen

					EXE_RequestDataFile_Loop:
						manageCurrentScreen backButton, EXE_Name_LABEL, nextButton, EXE_Name_LABEL
						jmp EXE_RequestDataFile_Loop

					jmp EXE_RequestDataFile_LABEL

			
		EXE_Loading_LABEL: ;===== Loading Screen =====
			enableStringBuffering [true]
			copyFileTypeToAlgorithmFiles currentReadFileName
				
			compare [runMode], '==', 'D'
			checkBooleanSingleJump [boolFlag], EXE_RunBLOWFISH_LABEL

			EXE_GenerateDataFile_LABEL:
				copyString password, insertedPassword
				initAllKeys
				createDataFile
				jmp EXE_RunBLOWFISH_LABEL

			EXE_RunBLOWFISH_LABEL:
				runAlgorithm [runMode]

				enableStringBuffering [false]

				compare [runMode], '==', 'E'
				checkBooleanSingleJump [boolFlag], EXE_DeleteEncryptionFiles_LABEL

				compare [runMode], '==', 'D'
				checkBooleanSingleJump [boolFlag], EXE_DeleteDecryptionFiles_LABEL

				EXE_DeleteEncryptionFiles_LABEL:
					renameFile encryptedFileName, currentReadFileName
					jmp EXE_ContinueToEndGame_LABEL
					
				EXE_DeleteDecryptionFiles_LABEL:
					renameFile decryptedFileName, currentReadFileName
					DeleteFile dataFileName
					
					jmp EXE_ContinueToEndGame_LABEL

				EXE_ContinueToEndGame_LABEL:
					setupButtons [false], [true], [false], [false], [false]
					enableStringBuffering [true]
					setNextScreenProperty status, STATUS_Loaded
					
					printScreen
					printString proccesProgressString, precentX, precentY
					 
			EXE_Loaded_Loop:
				manageCurrentScreen nextButton, EXE_EndGame_LABEL, backButton, EXE_EndGame_LABEL
				jmp EXE_Loaded_Loop
			
		EXE_EndGame_LABEL: ;===== End Game *SNAP* =====
			setupButtons [true], [false], [false], [false], [true]
			enableStringBuffering [false]
			
			printScreen

			EXE_EndGame_LOOP: ;=== End Game *SNAP Loop ===
				manageCurrentScreen backButton, exit, restartButton, start
				jmp EXE_EndGame_LOOP
exit:
switchGraphicsMode 't'

mov ax, 4C00h
int 21h
end start 