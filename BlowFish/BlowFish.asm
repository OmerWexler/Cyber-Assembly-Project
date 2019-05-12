macro runBlowFishALG RBFA_RunType_PARAM
	pushAll

	;Decide which function to call (encrypt or decrypt) based on provided bool
	;Call function.

	
	popAll
endm runBlowFishALG

;===== Loops through the correct encryption procedures =====
ECF_ZerosToDelete_VAR equ bp - 2
ECF_WasError_VAR equ bp - 4
proc encryptCurrentFile_PROC
	initBasicProc 4

	RBFA_RunLoop_LABEL:
	call preapareAlgorithm_PROC
	pop [boolFlag]

	call blowFishAlgorithmEncrypt_PROC


	checkBoolean [boolFlag], RBFA_RunLoop_LABEL

	endBasicProc 4
	ret 0
endp encryptCurrentFile_PROC

;===== Gets all the vital data ready for encryption every iteration =====
PA_WasLastRun_VAR equ bp - 2
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
		jmp PA_End_LABEL

	PA_PartialRead_LABEL:
		compare ax, '==', 0d

		mov dx, 8d
		sub dx, ax

		mov di, ax
		mov cx, dx
		PA_MoveNullZerosIntoBuffer_LABEL:
			add di, cx
			dec di

			mov al, 0d
			mov [byte ptr dataBlockBuffer + di], al 
			loop PA_MoveNullZerosIntoBuffer_LABEL

			setBoolean [PA_WasLastRun_VAR], [true]
			jmp PA_End_LABEL 

	PA_End_LABEL:
	push PA_WasLastRun_VAR
	
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
			mov [word ptr LStream + 2d], ax			

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
	ret
endp blowFishAlgorithmEncrypt_PROC 

;===== Writes to the file the last bytes and deletes the null zeroes from the end of it (if there is any) =====
proc finishEncryption_PROC

	
endp finishEncryption_PROC