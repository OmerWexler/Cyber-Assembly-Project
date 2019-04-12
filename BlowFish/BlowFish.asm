macro runBlowFishALG	
	pushAll

	call BlowFishAlgorithm_PROC
	
	popAll
endm runBlowFishALG

proc BlowFishAlgorithm_PROC
	
	initBasicProc 0
	
	mov ax, 1234h
	xor ax, [word ptr dataBlockBuffer + 0d]
	mov [word ptr dataBlockBuffer + 0d], ax

	xor ax, [word ptr dataBlockBuffer + 2d]
	mov [word ptr dataBlockBuffer + 2d], ax

	xor ax, [word ptr dataBlockBuffer + 4d]
	mov [word ptr dataBlockBuffer + 4d], ax

	xor ax, [word ptr dataBlockBuffer + 6d]
	mov [word ptr dataBlockBuffer + 6d], ax

	endBasicProc 0 
	ret
endp BlowFishAlgorithm_PROC 