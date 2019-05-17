;===== Creates a new file to write into =====
proc createNewReturnFile_PROC

	compare [runMode], '==', 'E'
	checkBoolean [boolFlag], CNRF_SetEncrypt_LABEL, CNRF_CheckIfDecryption_LABEL

	CNRF_CheckIfDecryption_LABEL:
		compare [runMode], '==', 'D'
		checkBoolean [boolFlag], CNRF_SetDecrypt_LABEL, CNRF_Exit_LABEL

	CNRF_SetEncrypt_LABEL:
		createFile encryptedFileName, [currentWriteFileHandle]
		jmp CNRF_Exit_LABEL

	CNRF_SetDecrypt_LABEL:
		createFile decryptedFileName, [currentWriteFileHandle]
		jmp CNRF_Exit_LABEL

	CNRF_Exit_LABEL:
	ret 0
endp createNewReturnFile_PROC

;===== Gets all the vital data ready for encryption every iteration =====
;Requires an extra macro for a return value allocation
macro prepareAlgorithm

	sub sp, 2d
	call preapareAlgorithm_PROC

endm prepareAlgorithm

;===== Reads all the vital data and arranges it correctly =====
PA_CharacterRead_VAR equ bp + 4
proc preapareAlgorithm_PROC
	initBasicProc 0

	readFromFile currentReadFileHandle, 8d, dataBlockBuffer

	mov [PA_CharacterRead_VAR], ax
	
	;Transfer the new data into the two streams.	
	PA_TransferIntoDataBlock_LABEL:
		mov ax, [word ptr dataBlockBuffer]
		mov [word ptr LStream], ax
		
		mov ax, [word ptr dataBlockBuffer + 2d]
		mov [word ptr LStream + 2d], ax

		mov ax, [word ptr dataBlockBuffer + 4d]
		mov [word ptr RStream], ax

		mov ax, [word ptr dataBlockBuffer + 6d]
		mov [word ptr RStream + 2d], ax

	endBasicProc 0
	ret 0	
endp preapareAlgorithm_PROC

;===== The actual encryption procedure =====
proc blowFishAlgorithmEncrypt_PROC
	
	initBasicProc 0
	BFAE_ALgorithmRun_LABEL:
		mov cx, 18d	
		BFAE_EncryptionLoop_LABEL:
			push cx

			;XOR LStream with Pkeys (key at position 19 - cx)
			mov ax, 19d
			sub ax, cx

			readFromKey 'p', ax
			
			xor ax, [word ptr LStream]
			mov [word ptr LStream], ax
			
			xor dx, [word ptr LStream + 2d]
			mov [word ptr LStream + 2d], dx			

			;Run FFunction (that encryptes LStream)
			FFunction
			
			;XOR modified LStream with RStream
			mov ax, [word ptr RStream]
			xor ax, [word ptr LStream]
			mov [word ptr RStream], ax
			
			mov ax, [word ptr RStream + 2d]
			xor ax, [word ptr LStream + 2d]
			mov [word ptr RStream + 2d], ax

			;Switch the data between them.
			mov ax, [word ptr RStream]
			mov dx, [word ptr LStream]

			mov [word ptr LStream], ax
			mov [word ptr RStream], dx
			
			mov ax, [word ptr RStream + 2d]
			mov dx, [word ptr LStream + 2d]

			mov [word ptr LStream + 2d], ax
			mov [word ptr RStream + 2d], dx

			;Repeat.
			pop cx
		loop BFAE_EncryptionLoop_LABEL
	
	endBasicProc 0 
	ret 0
endp blowFishAlgorithmEncrypt_PROC 

;===== The decryption algorithm =====
proc blowFishAlgorithmDecrypt_PROC
	initBasicProc 0
	
	BFAD_ALgorithmRun_LABEL:
		mov cx, 18d	
		BFAD_EncryptionLoop_LABEL:
			push cx

			;Switch the data between them.
			mov ax, [word ptr RStream]
			mov dx, [word ptr LStream]

			mov [word ptr LStream], ax
			mov [word ptr RStream], dx
			
			mov ax, [word ptr RStream + 2d]
			mov dx, [word ptr LStream + 2d]

			mov [word ptr LStream + 2d], ax
			mov [word ptr RStream + 2d], dx

			;XOR modified LStream with RStream
			mov ax, [word ptr RStream]
			xor ax, [word ptr LStream]
			mov [word ptr RStream], ax
			
			mov ax, [word ptr RStream + 2d]
			xor ax, [word ptr LStream + 2d]
			mov [word ptr RStream + 2d], ax

			;Run FFunction (that decryptes LStream)
			FFunction
			
			;XOR LStream with Pkeys (key at position cx)
			pop cx
			readFromKey 'p', cx
			push cx

			xor ax, [word ptr LStream]
			mov [word ptr LStream], ax
			
			xor dx, [word ptr LStream + 2d]
			mov [word ptr LStream + 2d], dx			

			;Repeat.
			pop cx
		loop BFAD_EncryptionLoop_LABEL
	
	endBasicProc 0 
	ret 0
endp blowFishAlgorithmDecrypt_PROC

;===== Writes to the file the last bytes and deletes the null zeroes from the end of it (if there is any) =====
FE_CharactersRead_VAR equ bp + 4 ;first is a parameter, then return value.
proc finishEncryption_PROC
	initBasicProc 0

	;Copy from streams into buffer
	mov ax, [word ptr LStream]
	mov [word ptr dataBlockBuffer], ax

	mov ax, [word ptr LStream + 2d]
	mov [word ptr dataBlockBuffer + 2d], ax

	mov ax, [word ptr RStream]
	mov [word ptr dataBlockBuffer + 4d], ax

	mov ax, [word ptr RStream + 2d]
	mov [word ptr dataBlockBuffer + 6d], ax
	
	mov ax, [FE_CharactersRead_VAR]
	writeToFile [currentWriteFileHandle], ax, dataBlockBuffer

	mov [FE_CharactersRead_VAR], ax

	endBasicProc 0
	ret 0 ;zero because there is a return value in the stack
endp finishEncryption_PROC

;===== A recursive procedure that runs the full algorithm loop =====
proc iterAlgoritm_PROC

	prepareAlgorithm ;the zeroes to delete is now inside the stack

	compare [runMode], '==', 'E'
	checkBoolean [boolFlag], IA_CallEncrypt_LABEL, IA_CheckIfDecryption_LABEL
	
	IA_CheckIfDecryption_LABEL:
		compare [runMode], '==', 'D'
		checkBoolean [boolFlag], IA_CallDecrypt_LABEL, IA_Exit_LABEL

	IA_CallEncrypt_LABEL:
		call blowFishAlgorithmEncrypt_PROC
		jmp IA_AfterAlgorithmRun_LABEL

	IA_CallDecrypt_LABEL:
		call blowFishAlgorithmDecrypt_PROC
		jmp IA_AfterAlgorithmRun_LABEL

	IA_AfterAlgorithmRun_LABEL:
		pop ax
		compare ax, '==', 8d
		push ax

		call finishEncryption_PROC
		add sp, 2 ;reorder stack after all the stack variables traveled fine

		checkBoolean [boolFlag], IA_Recall_LABEL, IA_Exit_LABEL ;checks the already set boolean flag

	IA_Recall_LABEL:
		call iterAlgoritm_PROC
	
	IA_Exit_LABEL:
	ret 0
endp iterAlgoritm_PROC

;===== Jumpstarts the recursive algorithm procedure =====
macro runAlgorithm RA_RunMode_VAR

	mov ax, RA_RunMode_VAR
	mov [runMode], ax 
	call runAlgorithm_PROC

	;reset password index
	mov ax, [currentPasswordIndex]
	xor ax, [currentPasswordIndex]
	mov [currentPasswordIndex], ax

endm runAlgorithm

proc runAlgorithm_PROC 
	initBasicProc 0
	
	call createNewReturnFile_PROC
	openFile currentReadFileName, currentReadFileHandle, 'r'

	call iterAlgoritm_PROC

	closeFile [currentReadFileHandle]
	closeFile [currentWriteFileHandle]

	endBasicProc 0
	ret 0
endp runAlgorithm_PROC