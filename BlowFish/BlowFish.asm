macro runBlowFishALG RBFA_RunType_PARAM
	pushAll

	;Decide which function to call (encrypt or decrypt) based on provided bool
	;Call function.

	
	popAll
endm runBlowFishALG

;===== Gets all the vital data ready for encryption every iteration =====
;Requires an extra macro for a return value allocation
macro prepareAlgorithm

	sub sp, 2
	call preapareAlgorithm_PROC

endm prepareAlgorithm

PA_ReturnValue_VAR equ bp + 4
PA_ZerosToDelete_VAR equ bp - 2
proc preapareAlgorithm_PROC
	initBasicProc 2

	readFromFile currentFileHandle, 8d, dataBlockBuffer

	compare [lastReadByteCount], '==', 8d
	checkBoolean [boolFlag], PA_FullRead_LABEL, PA_PartialRead_LABEL  

	PA_FullRead_LABEL:
	;Transfer the new data into the two streams.	
	PA_TransferIntoStreams_LABEL:
		mov ax, [word ptr dataBlockBuffer]
		mov [word ptr LStream], ax
		
		mov ax, [word ptr dataBlockBuffer + 2d]
		mov [word ptr LStream + 2d], ax

		mov ax, [word ptr dataBlockBuffer + 4d]
		mov [word ptr RStream], ax

		mov ax, [word ptr dataBlockBuffer + 6d]
		mov [word ptr RStream + 2d], ax

		mov ax, 0d
		mov [PA_ZerosToDelete_VAR], ax

		jmp PA_End_LABEL

	PA_PartialRead_LABEL:
		
		mov di, ax
		
		compare ax, '==', 0d

		mov dx, 8d
		sub dx, ax

		mov [PA_ZerosToDelete_VAR], dx
		mov cx, dx
		PA_MoveNullZerosIntoBuffer_LABEL:
			add di, cx
			dec di

			mov al, 0d
			mov [byte ptr dataBlockBuffer + di], al
			
			loop PA_MoveNullZerosIntoBuffer_LABEL
			
			jmp PA_End_LABEL 

	PA_End_LABEL:
	mov ax, [PA_ZerosToDelete_VAR]
	mov [PA_ReturnValue_VAR], ax
	
	endBasicProc 2
	ret 0	
endp preapareAlgorithm_PROC

;===== Loops through the correct encryption procedures =====
ECF_ZerosToDelete_VAR equ bp - 2
proc encryptCurrentFile_PROC
	initBasicProc 0

	RBFA_RunLoop_LABEL:
		prepareAlgorithm

		pop ax 
		mov [ECF_ZerosToDelete_VAR], ax
		
		call blowFishAlgorithmEncrypt_PROC
		
		compare [ECF_ZerosToDelete_VAR], '>', 0
		checkBoolean [boolFlag], RBFA_RemoveZeros_LABEL, RBFA_RunLoop_LABEL

		RBFA_RemoveZeros_LABEL:
			push [ECF_ZerosToDelete_VAR]
			call finishEncryption_PROC
	

	endBasicProc 0
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
FE_ZerosToDelete_VAR equ bp + 4
proc finishEncryption_PROC
	initBasicProc 0

	mov ax, [word ptr LStream]
	mov [word ptr dataBlockBuffer], ax

	mov ax, [word ptr LStream + 2d]
	mov [word ptr dataBlockBuffer + 2d], ax

	mov ax, [word ptr RStream]
	mov [word ptr dataBlockBuffer + 4d], ax

	mov ax, [word ptr RStream + 2d]
	mov [word ptr dataBlockBuffer + 6d], ax
	
	mov di, 8d
	sub di, [FE_ZerosToDelete_VAR]
	
	xor ax, ax
	mov al, [byte ptr dataBlockBuffer + di]
	push ax 
	
	mov al, Ascii_$
	mov [byte ptr dataBlockBuffer + di], al

	writeToFile [currentFileHandle], dataBlockBuffer

	endBasicProc 0
	ret 2
endp finishEncryption_PROC