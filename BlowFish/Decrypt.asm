;===== Gets all the vital data ready for decryption every iteration =====
;Requires an extra macro for a return value allocation
macro prepareDecryption

	sub sp, 2d
	call preapareDecryption_PROC

endm prepareDecryption

PD_CharacterRead_VAR equ bp + 4
proc preapareDecryption_PROC
	initBasicProc 0

	readFromFile currentFileHandle, 8d, dataBlockBuffer
	; add [readIndex], ax 

	mov [PD_CharacterRead_VAR], ax
	
	;Transfer the new data into the two streams.	
	PD_TransferIntoDataBlock_LABEL:
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
endp preapareDecryption_PROC

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
FE_ActionCharacters_VAR equ bp + 4 ;first is a parameter, then return value.
proc finishDecryption_PROC
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

	writeToFile [decryptFileHandle], dataBlockBuffer
	; add [writeIndex], ax

	mov [FE_ActionCharacters_VAR], ax

	pop ax
	mov [byte ptr dataBlockBuffer + di], al

	endBasicProc 0
	ret 0 ;zero because there is a return value in the stack
endp finishDecryption_PROC

;===== the procedure that runs all the proc in an ordered fashion =====
proc iterDecryption_PROC

	prepareDecryption ;the zeroes to delete is now inside the stack

	call blowFishAlgorithmDecrypt_PROC

	pop ax
	compare ax, '==', 8d
	push ax

	call finishDecryption_PROC
	add sp, 2

	checkBoolean [boolFlag], IE_Recall_LABEL, IE_Exit_LABEL

	IE_Recall_LABEL:
		call iterDecryption_PROC
	
	IE_Exit_LABEL:
	ret 0
endp iterDecryption_PROC

;===== Loops through the correct encryption procedures =====
proc decryptCurrentFile_PROC
	initBasicProc 0

	createFile decryptedFileName, [decryptFileHandle]

	call iterDecryption_PROC

	endBasicProc 0
	ret 0
endp decryptCurrentFile_PROC