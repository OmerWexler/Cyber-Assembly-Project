macro runBlowFishALG RBFA_RunType_PARAM
	pushAll

	;Decide which function to call (encrypt or decrypt) based on provided bool
	;Call function.

	
	popAll
endm runBlowFishALG

;===== Gets all the vital data ready for encryption every iteration =====
;Requires an extra macro for a return value allocation
macro prepareAlgorithm

	sub sp, 2d
	call preapareAlgorithm_PROC

endm prepareAlgorithm

PA_CharacterRead_VAR equ bp + 4
proc preapareAlgorithm_PROC
	initBasicProc 0

	readFromFile currentFileHandle, 8d, dataBlockBuffer

	mov [PA_CharacterRead_VAR], ax

	compare ax,'==', 8d
	checkBoolean [boolFlag], PA_TransferIntoDataBlock_LABEL, PA_RetryRead_LABEL

	PA_RetryRead_LABEL:
		mov ax, [PA_CharacterRead_VAR]
		mov dx, 8
		sub dx, ax

		readFromFile currentFileHandle, dx, dataBlockBuffer		


		

	PA_TransferIntoDataBlock_LABEL:
	;Transfer the new data into the two streams.	
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

;===== Loops through the correct encryption procedures =====
proc encryptCurrentFile_PROC
	initBasicProc 2

	createFile encryptedFileName, [encryptFileHandle]

	RBFA_RunLoop_LABEL:	

		prepareAlgorithm ;the zeroes to delete is now inside the stack

		call blowFishAlgorithmEncrypt_PROC
		
		pop ax
		compare ax, '==', 8d
		push ax
		
		call finishEncryption_PROC
		add sp, 2

		checkBoolean [boolFlag], RBFA_RunLoop_LABEL, RBFA_Exit_LABEL

	RBFA_Exit_LABEL:
		
		; deleteFile encryptedFileName
	endBasicProc 2
	ret 0
endp encryptCurrentFile_PROC


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

;===== Writes to the file the last bytes and deletes the null zeroes from the end of it (if there is any) =====
FE_ActionCharacters_VAR equ bp + 4 ;first is a parameter, then return value.
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
	
	mov di, [FE_ActionCharacters_VAR]

	xor ax, ax
	mov al, [byte ptr dataBlockBuffer + di]
	push ax 
	
	mov al, Ascii_$
	mov [byte ptr dataBlockBuffer + di], al

	writeToFile [encryptFileHandle], dataBlockBuffer
	
	mov [FE_ActionCharacters_VAR], ax

	pop ax
	mov [byte ptr dataBlockBuffer + di], al

	endBasicProc 0
	ret 0 ;zero because there is a return value in the stack
endp finishEncryption_PROC