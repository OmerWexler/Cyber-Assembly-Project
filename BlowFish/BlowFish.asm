macro runBlowFishALG RBFA_RunType_PARAM
	pushAll

	;Decide which function to call (encrypt or decrypt) based on provided bool
	;Call function.
	call preapareAlgorithm_PROC
	call blowFishAlgorithmEncrypt_PROC
	
	popAll
endm runBlowFishALG

;===== Gets all the vital data ready =====
proc preapareAlgorithm_PROC
	initBasicProc 0

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

	PA_PartialRead_LABEL:
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
			
			;XOR LStream with RStream
			mov ax, [word ptr RStream]
			xor ax, [word ptr LStream]
			mov [word ptr RStream], ax
			
			mov ax, [word ptr RStream + 2d]
			xor ax, [word ptr LStream + 2d]
			mov [word ptr RStream + 2d], ax

			;Switch the data between them.
			mov ax, [word ptr RStream]
			mov ax, [word ptr RStream + 2d]
			
			push [word ptr LStream]
			push [word ptr LStream + 2d]
			
			mov [word ptr LStream]
			;Repeat.
			pop cx
			loop BFAE_EncryptionLoop_LABEL
	
	endBasicProc 0 
	ret
endp blowFishAlgorithmEncrypt_PROC 

proc blowFishAlgorithmDecrypt_PROC

	

endp blowFishAlgorithmDecrypt_PROC